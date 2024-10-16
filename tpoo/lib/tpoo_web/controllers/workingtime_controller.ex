defmodule TpooWeb.WorkingtimeController do
  use TpooWeb, :controller
  alias Tpoo.Repo
  alias Tpoo.Accounts
  alias Tpoo.Accounts.Workingtime

  action_fallback TpooWeb.FallbackController

  # GET /api/workingtime/:userID?start=XXX&end=YYY
  def index(conn, %{"user_id" => user_id, "start" => start_time, "end" => end_time}) do
    with {:ok, start_time} <- DateTime.from_iso8601(start_time),
         {:ok, end_time} <- DateTime.from_iso8601(end_time) do
      workingtimes = Accounts.list_workingtimes(user_id, start_time, end_time)
      render(conn, :index, workingtimes: workingtimes)
    else
      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Invalid start or end time format."})
    end
  end

  # GET /api/workingtime/:userID (pour obtenir toutes les heures de travail sans plage de dates)
  def index(conn, %{"user_id" => user_id}) do
    workingtimes = Accounts.list_workingtimes(user_id)
    render(conn, :index, workingtimes: workingtimes)
  end

  # GET /api/workingtime/:userID/:id
  def show(conn, %{"user_id" => user_id, "id" => id}) do
    case Accounts.get_workingtime(user_id, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Workingtime not found"})
      workingtime ->
        render(conn, :show, workingtime: workingtime)
    end
  end

  # POST /api/workingtime/:userID
  def create(conn, %{"user_id" => user_id, "workingtime" => workingtime_params}) do
    workingtime_params = Map.put(workingtime_params, "user_id", user_id)

    # Simplification: Retirer temporairement les validations pour isoler le problème
    changeset = %Workingtime{}
    |> Ecto.Changeset.cast(workingtime_params, [:start, :end, :user_id])
    |> Ecto.Changeset.validate_required([:start, :end, :user_id])

    case Repo.insert(changeset) do
      {:ok, workingtime} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/workingtime/#{user_id}/#{workingtime.id}")
        |> render(:show, workingtime: workingtime)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: translate_errors(changeset)})
    end
  end

  # PUT /api/workingtime/:userID/:id
  def update(conn, %{"user_id" => user_id, "id" => id, "workingtime" => workingtime_params}) do
    case Accounts.get_workingtime(user_id, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Workingtime not found"})
      workingtime ->
        with {:ok, %Workingtime{} = updated_workingtime} <- Accounts.update_workingtime(workingtime, workingtime_params) do
          render(conn, :show, workingtime: updated_workingtime)
        else
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{errors: translate_errors(changeset)})
        end
    end
  end

  # DELETE /api/workingtime/:userID/:id
  def delete(conn, %{"user_id" => user_id, "id" => id}) do
    case Accounts.get_workingtime(user_id, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Workingtime not found"})
      workingtime ->
        with {:ok, %Workingtime{}} <- Accounts.delete_workingtime(workingtime) do
          send_resp(conn, :no_content, "")
        else
          _ ->
            conn
            |> put_status(:internal_server_error)
            |> json(%{error: "Unable to delete workingtime"})
        end
    end
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  defp translate_error({msg, _opts}) do
    msg
  end
end

defmodule TpooWeb.UserController do
  use TpooWeb, :controller

  alias Tpoo.Accounts
  alias Tpoo.Accounts.User

  action_fallback TpooWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  def create(conn, user_params) do
    if valid_email?(user_params["email"]) do
      with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/users/#{user.id}")
        |> render(:show, user: user)
      end
    else
      conn
      |> put_status(:bad_request)
      |> json(%{error: "Invalid email format"})
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id} = user_params) do
    if valid_email?(user_params["email"]) do
      user = Accounts.get_user!(id)

      with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
        render(conn, :show, user: user)
      end
    else
      conn
      |> put_status(:bad_request)
      |> json(%{error: "Invalid email format"})
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  defp valid_email?(email) do
    Regex.match?(~r/^[\w._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/, email)
  end
end

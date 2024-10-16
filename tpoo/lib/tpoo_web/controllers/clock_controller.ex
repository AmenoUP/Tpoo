defmodule TpooWeb.ClockController do
  use TpooWeb, :controller

  alias Tpoo.Accounts
  alias Tpoo.Accounts.Clock

  action_fallback TpooWeb.FallbackController

  def index(conn, _params) do
    clocks = Accounts.list_clocks()
    render(conn, :index, clocks: clocks)
  end

  def create(conn, clock_params) do

    current_time         = DateTime.utc_now()
    updated_clock_params = Map.put(clock_params, "time", current_time)

    with {:ok, %Clock{} = clock} <- Accounts.create_clock(updated_clock_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/clocks/#{clock.id}")
      |> render(:show, clock: clock)
    end
  end

  def show(conn, %{"user_id" => user_id}) do
    clocks = Accounts.get_clocks_by_user_id(user_id)

    case clocks do
      [] ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "No clocks found for this user"})
      _ ->
        render(conn, "show_clocks.json", clocks: clocks)
    end
  end

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = Accounts.get_clock!(id)

    with {:ok, %Clock{} = clock} <- Accounts.update_clock(clock, clock_params) do
      render(conn, :show, clock: clock)
    end
  end

  def delete(conn, %{"id" => id}) do
    clock = Accounts.get_clock!(id)

    with {:ok, %Clock{}} <- Accounts.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end
end

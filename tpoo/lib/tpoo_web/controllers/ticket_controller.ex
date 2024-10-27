defmodule TpooWeb.TicketController do
  use TpooWeb, :controller
  alias Tpoo.Accounts
  alias Tpoo.Accounts.Ticket

  action_fallback TpooWeb.FallbackController

  # GET /tickets
  def index(conn, _params) do
    tickets = Accounts.list_tickets()
    json(conn, %{data: Enum.map(tickets, &ticket_json/1)})
  end

  def ticket_json(%Ticket{} = ticket) do
    %{
      id: ticket.id,
      objet: ticket.objet,
      issue: ticket.issue,
      user_id: ticket.user_id,
      inserted_at: ticket.inserted_at,
      updated_at: ticket.updated_at
    }
  end

  # GET /tickets/:id
  def show(conn, %{"id" => id}) do
    case Accounts.get_ticket(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Ticket not found"})

      ticket ->
        render(conn, "show.json", ticket: ticket)
    end
  end

  def create(conn, %{"ticket" => ticket_params, "user_id" => user_id}) do
    updated_params = Map.put(ticket_params, "user_id", String.to_integer(user_id))

    # Change here
    case Accounts.create_ticket(updated_params) do
      {:ok, ticket} ->
        conn
        |> put_status(:created)
        |> render("show.json", ticket: ticket)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TpooWeb.ChangesetJSON, "error.json", changeset: changeset)
    end
  end

  # DELETE /tickets/:id
  def delete(conn, %{"id" => id}) do
    case Accounts.delete_ticket(id) do
      {:ok, %Ticket{}} ->
        send_resp(conn, :no_content, "")

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Ticket not found"})

      {:error, reason} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: reason})
    end
  end
end

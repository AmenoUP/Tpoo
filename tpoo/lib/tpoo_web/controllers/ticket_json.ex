defmodule TpooWeb.TicketJSON do
  alias Tpoo.Accounts.Ticket

  @moduledoc false

  # Fonction pour gérer la réponse lorsque plusieurs tickets sont récupérés
  def index(tickets) do
    data = Enum.map(tickets, &ticket_json/1)
    %{data: data}
  end

  # Fonction pour transformer un ticket individuel en JSON
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

  # Si vous avez une fonction pour afficher un seul ticket
  def show(%{ticket: %Ticket{} = ticket}) do
    ticket_json(ticket)
  end
end

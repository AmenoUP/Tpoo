defmodule Tpoo.Accounts.Ticket do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tickets" do
    field :objet, :string
    field :issue, :string
    belongs_to :user, Tpoo.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, [:objet, :issue, :user_id])
    |> validate_required([:objet, :issue, :user_id])
    |> assoc_constraint(:user)
  end
end

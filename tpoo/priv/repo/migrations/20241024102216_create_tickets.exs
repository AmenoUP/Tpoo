defmodule Tpoo.Repo.Migrations.CreateTickets do
  use Ecto.Migration
  def change do
    create table(:tickets) do
      add :objet, :string
      add :issue, :string
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:tickets, [:user_id])
  end
end

defmodule Tpoo.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :label, :string, null: false
      add :manager_id, references(:users, on_delete: :nilify_all), null: false  # Foreign key to users (manager)

      timestamps(type: :utc_datetime)
    end

    create index(:teams, [:manager_id])
  end
end

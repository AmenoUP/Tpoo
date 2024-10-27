defmodule Tpoo.Repo.Migrations.CreateWorkingtime do
  use Ecto.Migration

  def change do
    create table(:workingtime) do
      add :start, :utc_datetime, null: false
      add :end, :utc_datetime, null: false

      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:workingtime, [:user_id])
    create constraint(:workingtime, :check_end_after_start, check: "\"end\" > start")
  end
end
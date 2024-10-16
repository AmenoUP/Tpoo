defmodule MyApp.Repo.Migrations.CreateWorkingTime do
  use Ecto.Migration

  def change do
    create table(:workingtime) do
      add :start_time, :utc_datetime, null: false
      add :end_time, :utc_datetime, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create constraint(:workingtime, :check_end_after_start, check: "end_time > start_time")
  end
end

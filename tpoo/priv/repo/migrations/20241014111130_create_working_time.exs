defmodule MyApp.Repo.Migrations.CreateWorkingTime do
  use Ecto.Migration

  def change do
    create table(:workingtime) do
      add :start, :utc_datetime, null: false
      add :end, :utc_datetime, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    # Utilisation de guillemets doubles pour le nom de la colonne 'end'
    create constraint(:workingtime, :check_end_after_start, check: "\"end\" > start")
  end
end
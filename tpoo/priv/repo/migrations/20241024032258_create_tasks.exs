defmodule Tpoo.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :label, :string, null: false
      add :description, :string
      add :status, :boolean, defaul: false, null: false

      add :skill_id, references(:skills, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:tasks, [:skill_id])
  end
end

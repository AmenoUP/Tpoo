defmodule Tpoo.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :label, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:roles, [:label])
  end
end

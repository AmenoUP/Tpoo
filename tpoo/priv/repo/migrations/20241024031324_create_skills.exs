defmodule Tpoo.Repo.Migrations.CreateSkills do
  use Ecto.Migration

  def change do
    create table(:skills) do
      add :label, :string, null: false

      timestamps(type: :utc_datetime)
    end
  end
end

defmodule Tpoo.Repo.Migrations.CreateUsersSkills do
  use Ecto.Migration

  def change do
    create table(:users_skills) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :skill_id, references(:skills, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:users_skills, [:user_id])
    create index(:users_skills, [:skill_id])
  end
end

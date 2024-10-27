defmodule MyApp.Repo.Migrations.AddFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :is_admin, :boolean, default: false, null: false
      add :is_manager, :boolean, default: false, null: false
      add :password, :string, null: false
    end

    execute """
    INSERT INTO users (username, email, password, is_admin, is_manager, inserted_at, updated_at)
    VALUES ('admin', 'admin@gmail.com', 'admin', true, false, now(), now())
    """
  end
end

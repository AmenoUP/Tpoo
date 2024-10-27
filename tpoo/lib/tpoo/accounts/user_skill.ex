defmodule Tpoo.Accounts.User_skill do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users_skills" do
    belongs_to :user, Tpoo.Accounts.User
    belongs_to :skill, Tpoo.Accounts.Skill

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_skill, attrs) do
    user_skill
    |> cast(attrs, [])
    |> validate_required([])
  end
end

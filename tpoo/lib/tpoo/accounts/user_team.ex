defmodule Tpoo.User_team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users_teams" do

    belongs_to :user, Tpoo.Accounts.User
    belongs_to :team, Tpoo.Accounts.Team

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_team, attrs) do
    user_team
    |> cast(attrs, [])
    |> validate_required([])
  end
end

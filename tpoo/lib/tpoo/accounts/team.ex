defmodule Tpoo.Accounts.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :label, :string

    belongs_to :manager, Tpoo.Accounts.User, foreign_key: :manager_id  # A team has one manager (user)
    many_to_many :users, Tpoo.Accounts.User, join_through: "users_teams"


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:label, :manager_id])
    |> validate_required([:label, :manager_id])
  end
end

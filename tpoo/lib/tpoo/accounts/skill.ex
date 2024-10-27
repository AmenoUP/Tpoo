defmodule Tpoo.Accounts.Skill do
  use Ecto.Schema
  import Ecto.Changeset

  schema "skills" do
    field :label, :string

    has_many :tasks, Tpoo.Accounts.Task  # A skill can have many tasks
    many_to_many :users, Tpoo.Accounts.User, join_through: "users_skills"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(skill, attrs) do
    skill
    |> cast(attrs, [:label])
    |> validate_required([:label])
  end
end

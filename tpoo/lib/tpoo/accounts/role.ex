defmodule Tpoo.Accounts.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field :label, :string

    has_many :users, Tpoo.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @required_roles ["Manager", "User"]  # Mandatory roles

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:label])
    |> validate_required([:label])
    |> validate_inclusion(:name, @required_roles)
  end
end

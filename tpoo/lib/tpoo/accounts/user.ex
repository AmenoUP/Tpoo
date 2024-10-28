defmodule Tpoo.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string
    field :is_admin, :boolean, default: false
    field :is_manager, :boolean, default: false
    field :password, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :is_admin, :is_manager, :password])
    |> validate_required([:username, :email, :password])
    |> validate_format(:email, ~r/^[\w._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/, message: "must be a valid email address")
    |> unique_constraint(:email)
  end
end

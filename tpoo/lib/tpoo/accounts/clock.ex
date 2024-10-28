defmodule Tpoo.Accounts.Clock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clocks" do
    field :status, :boolean, default: false
    field :time, :utc_datetime_usec, default: DateTime.utc_now()
    field :user_id, :id

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(clock, attrs) do
    clock
    |> cast(attrs, [:time, :status, :user_id])
    |> validate_required([:status, :user_id])
  end
end

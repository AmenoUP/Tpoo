defmodule Tpoo.Accounts.Clock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clocks" do


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(clock, attrs) do
    clock
    |> cast(attrs, [])
    |> validate_required([])
  end
end

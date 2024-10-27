defmodule Tpoo.Accounts.Workingtime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workingtime" do

    field :start, :naive_datetime
    field :end, :naive_datetime

    belongs_to :user, Tpoo.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(workingtime, attrs) do
    workingtime
    |> cast(attrs, [:start, :end, :user_id])
    |> validate_required([:start, :end, :user_id])
    |> validate_change(:end, fn :end, end_time ->  # Validation de l'heure de fin
      case workingtime.start do
        nil -> []
        start_time ->
          if NaiveDateTime.compare(end_time, start_time) != :gt do
            [end: "End time must be after start time"]
          else
            []
          end
      end
    end)
  end
end

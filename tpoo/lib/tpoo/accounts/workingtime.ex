defmodule Tpoo.Accounts.Workingtime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workingtime" do
    field :start, :naive_datetime  # Garder :naive_datetime
    field :end, :naive_datetime    # Garder :naive_datetime
    field :user_id, :id            # Garder user_id

    timestamps(type: :utc_datetime)  # Garder les timestamps
  end

  @doc false
  def changeset(workingtime, attrs) do
    workingtime
    |> cast(attrs, [:start, :end, :user_id])  # Ajout de :user_id dans le cast
    |> validate_required([:start, :end, :user_id])  # Validation de la présence de user_id
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

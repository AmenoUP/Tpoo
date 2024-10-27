defmodule Tpoo.Accounts.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :label, :string
    field :description, :string
    field :status, :boolean

    belongs_to :skill, Tpoo.Accounts.Skill

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:label, :skill_id])
    |> validate_required([:label, :skill_id])
  end
end

defmodule Pelnance.Types.Type do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "types" do
    field :name, :string
    field :icon, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(type, attrs) do
    type
    |> cast(attrs, [:name, :icon])
    |> validate_required([:name, :icon])
  end
end

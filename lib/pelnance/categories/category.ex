defmodule Pelnance.Categories.Category do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "categories" do
    field :name, :string
    belongs_to :user, Pelnance.Categories.Category
    belongs_to :type, Pelnance.Types.Type

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :type_id, :user_id])
    |> validate_required([:name, :type_id, :user_id])
  end
end

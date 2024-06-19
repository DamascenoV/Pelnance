defmodule Pelnance.Types.Type do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "types" do
    field :name, :string
    field :subtraction, :boolean, default: false
    belongs_to :user, Pelnance.Users.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(type, attrs) do
    type
    |> cast(attrs, [:name, :subtraction, :user_id])
    |> validate_required([:name, :subtraction, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end

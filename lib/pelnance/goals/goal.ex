defmodule Pelnance.Goals.Goal do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "goals" do
    field :name, :string
    field :description, :string
    field :amount, :decimal, default: 0
    field :done, :boolean, default: false
    belongs_to :user, Pelnance.Users.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(goal, attrs) do
    goal
    |> cast(attrs, [:name, :done, :description, :amount, :user_id])
    |> validate_required([:name, :done, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end

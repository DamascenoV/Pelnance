defmodule Pelnance.Currencies.Currency do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:name, :symbol],
    sortable: [:name, :symbol],
    max_limit: 5,
    default_limit: 5,
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "currencies" do
    field :name, :string
    field :symbol, :string
    belongs_to :user, Pelnance.Users.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(currency, attrs) do
    currency
    |> cast(attrs, [:name, :symbol, :user_id])
    |> validate_required([:name, :symbol, :user_id])
  end
end

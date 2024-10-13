defmodule Pelnance.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [
      :name,
      :balance,
    ],
    sortable: [
      :name,
      :balance,
    ],
    max_limit: 5,
    default_limit: 5,
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :name, :string
    field :balance, :decimal
    belongs_to :currency, Pelnance.Currencies.Currency
    belongs_to :user, Pelnance.Users.User
    has_many :transactions, Pelnance.Transactions.Transaction

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name, :balance, :currency_id, :user_id])
    |> validate_required([:name, :balance, :currency_id, :user_id])
    |> foreign_key_constraint(:currency_id)
    |> foreign_key_constraint(:user_id)
  end
end

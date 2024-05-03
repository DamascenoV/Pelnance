defmodule Pelnance.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "transactions" do
    field :date, :date
    field :description, :string
    field :amount, :decimal
    belongs_to :type, Pelnance.Types.Type
    belongs_to :category, Pelnance.Categories.Category
    belongs_to :account, Pelnance.Accounts.Account

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:date, :amount, :description, :type_id, :category_id, :account_id])
    |> validate_required([:date, :amount, :description, :type_id, :category_id, :account_id])
    |> foreign_key_constraint(:type_id)
    |> foreign_key_constraint(:category_id)
    |> foreign_key_constraint(:account_id)
  end
end

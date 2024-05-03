defmodule Pelnance.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :balance, :decimal
      add :currency_id, references(:currencies, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:accounts, [:currency_id])
    create index(:accounts, [:user_id])
  end
end

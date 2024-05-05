defmodule Pelnance.Repo.Migrations.CreateTypes do
  use Ecto.Migration

  def change do
    create table(:types, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :icon, :string
      add :subtraction, :boolean, default: false
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:types, [:user_id])
  end
end

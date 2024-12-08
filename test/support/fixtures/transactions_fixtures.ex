defmodule Pelnance.TransactionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pelnance.Transactions` context.
  """

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        "amount" => "120.5",
        "date" => ~D[2024-05-02],
        "description" => "some description"
      })

    {:ok, transaction} =
      Pelnance.Transactions.create_transaction(attrs)

    transaction
  end
end

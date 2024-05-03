defmodule Pelnance.CurrenciesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pelnance.Currencies` context.
  """

  @doc """
  Generate a currency.
  """
  def currency_fixture(attrs \\ %{}) do
    {:ok, currency} =
      attrs
      |> Enum.into(%{
        name: "some name",
        symbol: "some symbol"
      })
      |> Pelnance.Currencies.create_currency()

    currency
  end
end

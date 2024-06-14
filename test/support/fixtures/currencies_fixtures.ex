defmodule Pelnance.CurrenciesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pelnance.Currencies` context.
  """

  @doc """
  Generate a currency.
  """
  def currency_fixture(user = %Pelnance.Users.User{}, attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        name: "some name",
        symbol: "some symbol"
      })

    {:ok, currency} =
      Pelnance.Currencies.create_currency(user, attrs)

    currency
  end
end

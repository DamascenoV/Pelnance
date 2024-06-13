defmodule Pelnance.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pelnance.Accounts` context.
  """

  @doc """
  Generate a account.
  """
  def account_fixture(user, attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        balance: "120.5",
        name: "some name"
      })

    {:ok, account} =
      Pelnance.Accounts.create_account(user, attrs)

    account
  end
end

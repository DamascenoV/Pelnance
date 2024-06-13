defmodule Pelnance.AccountsTest do
  use Pelnance.DataCase

  alias Pelnance.Accounts

  describe "accounts" do
    alias Pelnance.Accounts.Account

    import Pelnance.AccountsFixtures
    import Pelnance.UsersFixtures
    import Pelnance.CurrenciesFixtures

    @invalid_attrs %{name: nil, balance: nil}

    test "list_accounts/0 returns all accounts" do
      user = user_fixture()
      currency = currency_fixture(user)

      account =
        account_fixture(user, %{currency_id: currency.id})

      assert Accounts.list_accounts(user) == [account]
    end

    test "get_account!/1 returns the account with given id" do
      user = user_fixture()
      currency = currency_fixture(user)

      account =
        account_fixture(user, %{currency_id: currency.id})

      assert Accounts.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      user = user_fixture()
      currency = currency_fixture(user)
      valid_attrs = %{name: "some name", balance: "120.5", currency_id: currency.id}

      assert {:ok, %Account{} = account} = Accounts.create_account(user, valid_attrs)
      assert account.name == "some name"
      assert account.balance == Decimal.new("120.5")
      assert account.user_id == user.id
      assert account.currency_id == currency.id
    end

    test "create_account/1 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(user, @invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      user = user_fixture()
      currency = currency_fixture(user)

      account =
        account_fixture(user, %{currency_id: currency.id})

      update_attrs = %{name: "some updated name", balance: "456.7"}

      assert {:ok, %Account{} = account} = Accounts.update_account(account, update_attrs)
      assert account.name == "some updated name"
      assert account.balance == Decimal.new("456.7")
    end

    test "update_account/2 with invalid data returns error changeset" do
      user = user_fixture()
      currency = currency_fixture(user)

      account =
        account_fixture(user, %{currency_id: currency.id})

      assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, @invalid_attrs)
      assert account == Accounts.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      user = user_fixture()
      currency = currency_fixture(user)

      account =
        account_fixture(user, %{currency_id: currency.id})

      assert {:ok, %Account{}} = Accounts.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      user = user_fixture()
      currency = currency_fixture(user)

      account =
        account_fixture(user, %{currency_id: currency.id})

      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end
  end
end

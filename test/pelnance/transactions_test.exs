defmodule Pelnance.TransactionsTest do
  use Pelnance.DataCase

  alias Pelnance.Transactions

  describe "transactions" do
    alias Pelnance.Transactions.Transaction

    import Pelnance.TransactionsFixtures
    import Pelnance.UsersFixtures
    import Pelnance.TypesFixtures
    import Pelnance.CategoriesFixtures
    import Pelnance.AccountsFixtures
    import Pelnance.CurrenciesFixtures

    @invalid_attrs %{
      "date" => nil,
      "description" => nil,
      "amount" => nil,
      "account_id" => nil,
      "category_id" => nil,
      "type_id" => nil
    }

    test "list_transactions/0 returns all transactions" do
      user = user_fixture()
      type = type_fixture()
      currency = currency_fixture(user)
      category = category_fixture(user, %{type_id: type.id})
      account = account_fixture(user, %{currency_id: currency.id})

      transaction =
        transaction_fixture(%{
          "account_id" => account.id,
          "category_id" => category.id,
          "type_id" => type.id
        })

      assert Transactions.list_transactions(user) == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      user = user_fixture()
      type = type_fixture()
      category = category_fixture(user, %{type_id: type.id})
      currency = currency_fixture(user)
      account = account_fixture(user, %{currency_id: currency.id})

      transaction =
        transaction_fixture(%{
          "account_id" => account.id,
          "category_id" => category.id,
          "type_id" => type.id
        })

      assert Transactions.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      user = user_fixture()
      type = type_fixture()
      category = category_fixture(user, %{type_id: type.id})
      currency = currency_fixture(user)
      account = account_fixture(user, %{currency_id: currency.id})

      valid_attrs = %{
        "date" => ~D[2024-05-02],
        "description" => "some description",
        "amount" => "120.5",
        "account_id" => account.id,
        "category_id" => category.id,
        "type_id" => type.id
      }

      assert {:ok, %Transaction{} = transaction} = Transactions.create_transaction(valid_attrs)
      assert transaction.date == ~D[2024-05-02]
      assert transaction.description == "some description"
      assert transaction.amount == Decimal.new("120.5")
      assert transaction.account_id == account.id
      assert transaction.category_id == category.id
      assert transaction.type_id == type.id
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      user = user_fixture()
      currency = currency_fixture(user)
      type = type_fixture()
      category = category_fixture(user, %{type_id: type.id})
      account = account_fixture(user, %{currency_id: currency.id})

      assert {:error, %Ecto.Changeset{}} =
               Transactions.create_transaction(%{
                 "date" => ~D[2024-05-02],
                 "description" => "some description",
                 "amount" => nil,
                 "account_id" => account.id,
                 "category_id" => category.id,
                 "type_id" => type.id
               })
    end

    test "update_transaction/2 with valid data updates the transaction" do
      user = user_fixture()
      type = type_fixture()
      category = category_fixture(user, %{type_id: type.id})
      currency = currency_fixture(user)
      account = account_fixture(user, %{currency_id: currency.id})

      transaction =
        transaction_fixture(%{
          "account_id" => account.id,
          "category_id" => category.id,
          "type_id" => type.id
        })

      update_attrs = %{
        date: ~D[2024-05-03],
        description: "some updated description",
        amount: "456.7"
      }

      assert {:ok, %Transaction{} = transaction} =
               Transactions.update_transaction(transaction, update_attrs)

      assert transaction.date == ~D[2024-05-03]
      assert transaction.description == "some updated description"
      assert transaction.amount == Decimal.new("456.7")
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      user = user_fixture()
      type = type_fixture()
      category = category_fixture(user, %{type_id: type.id})
      currency = currency_fixture(user)
      account = account_fixture(user, %{currency_id: currency.id})

      transaction =
        transaction_fixture(%{
          "account_id" => account.id,
          "category_id" => category.id,
          "type_id" => type.id
        })

      assert {:error, %Ecto.Changeset{}} =
               Transactions.update_transaction(transaction, @invalid_attrs)

      assert transaction == Transactions.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      user = user_fixture()
      type = type_fixture()
      category = category_fixture(user, %{type_id: type.id})
      currency = currency_fixture(user)
      account = account_fixture(user, %{currency_id: currency.id})

      transaction =
        transaction_fixture(%{
          "account_id" => account.id,
          "category_id" => category.id,
          "type_id" => type.id
        })

      assert {:ok, %Transaction{}} = Transactions.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      user = user_fixture()
      type = type_fixture()
      category = category_fixture(user, %{type_id: type.id})
      currency = currency_fixture(user)
      account = account_fixture(user, %{currency_id: currency.id})

      transaction =
        transaction_fixture(%{
          "account_id" => account.id,
          "category_id" => category.id,
          "type_id" => type.id
        })

      assert %Ecto.Changeset{} = Transactions.change_transaction(transaction)
    end
  end
end

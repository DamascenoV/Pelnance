defmodule Pelnance.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Pelnance.Repo

  alias Pelnance.Accounts.Account
  alias Pelnance.Transactions.Transaction
  alias Pelnance.Users.User

  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts(%User{})
      [%Account{}, ...]

  """
  def list_accounts(user = %User{}) do
    Repo.all(from a in Account, where: a.user_id == ^user.id)
  end

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(%User{}, %{field: value})
      {:ok, %Account{}}

      iex> create_account(%User{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(user = %User{}, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:accounts)
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a account.

  ## Examples

      iex> delete_account(account)
      {:ok, %Account{}}

      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{data: %Account{}}

  """
  def change_account(%Account{} = account, attrs \\ %{}) do
    Account.changeset(account, attrs)
  end

  def get_balance_from_transactions!(account = %Account{}) do
    transactions = load_transactions(account.id)
    {expenses, income} = calculate_expenses_and_income(transactions)

    calculate_total(account.balance, expenses, income)
    |> :erlang.float_to_binary(decimals: 2)
  end

  defp load_transactions(account_id) do
    Repo.all(from t in Transaction, where: t.account_id == ^account_id)
    |> Repo.preload(:type)
  end

  defp calculate_expenses_and_income(transactions) do
    Enum.reduce(transactions, {0, 0}, fn t, {acc_expenses, acc_income} ->
      case t.type.subtraction do
        false -> {acc_expenses, acc_income + Decimal.to_float(t.amount)}
        true -> {acc_expenses - Decimal.to_float(t.amount), acc_income}
      end
    end)
  end

  defp calculate_total(balance, expenses, income) do
    Decimal.to_float(balance) + income + expenses
  end
end

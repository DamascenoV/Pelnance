defmodule Pelnance.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Pelnance.Repo
  alias Pelnance.Types

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
    Repo.all(from a in Account, where: a.user_id == ^user.id, preload: [:currency])
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
  def get_account!(id), do: Repo.get!(Account, id) |> Repo.preload([:currency])

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(%User{}, %{field: value})
      {:ok, %Account{}}

      iex> create_account(%User{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(user = %User{}, attrs \\ %{}) do
    account =
      user
      |> Ecto.build_assoc(:accounts)
      |> Account.changeset(attrs)
      |> Repo.insert()

    case account do
      {:ok, account} -> {:ok, account |> Repo.preload([:currency])}
      {:error, changeset} -> {:error, changeset}
    end
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
    case account |> Account.changeset(attrs) |> Repo.update() do
      {:ok, account} -> {:ok, account |> Repo.preload([:currency])}
      {:error, changeset} -> {:error, changeset}
    end
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

  @doc """
  Updates the balance of an account.

  ## Examples

      iex> update_balance(:insert, %Transaction{})
      {:ok, %Account{}}
  """
  def update_balance(:insert, transaction = %Transaction{}) do
    type = Types.get_type!(transaction.type_id)
    account = get_account!(transaction.account_id)

    amount =
      case type.subtraction do
        false -> Decimal.to_float(transaction.amount) + Decimal.to_float(account.balance)
        true -> Decimal.to_float(account.balance) - Decimal.to_float(transaction.amount)
      end

    account
    |> Account.changeset(%{balance: amount})
    |> Repo.update()
  end

  # TODO
  def update_balance(:edit, transaction = %Transaction{}) do
    type = Types.get_type!(transaction.type_id)
    account = get_account!(transaction.account_id)

    amount =
      case type.subtraction do
        false ->
          Decimal.to_float(transaction.amount) + Decimal.to_float(transaction.account_balance)

        true ->
          Decimal.to_float(transaction.account_balance) - Decimal.to_float(transaction.amount)
      end

    account
    |> Account.changeset(%{balance: amount})
    |> Repo.update()
  end

  def update_balance(:delete, transaction = %Transaction{}) do
    type = Types.get_type!(transaction.type_id)
    account = get_account!(transaction.account_id)

    amount =
      case type.subtraction do
        false -> Decimal.to_float(account.balance) - Decimal.to_float(transaction.amount)
        true -> Decimal.to_float(transaction.amount) + Decimal.to_float(account.balance)
      end

    account
    |> Account.changeset(%{balance: amount})
    |> Repo.update()
  end
end

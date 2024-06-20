defmodule Pelnance.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias Pelnance.Repo

  alias Pelnance.Accounts
  alias Pelnance.Transactions.Transaction
  alias Pelnance.Users.User

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

  """
  def list_transactions do
    Repo.all(Transaction)
  end

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions(%User{})
      [%Transaction{}, ...]

  """
  def list_transactions(user = %User{}) do
    Repo.all(
      from t in Transaction,
        join: a in assoc(t, :account),
        where: a.user_id == ^user.id,
        preload: [:type, :category]
    )
  end

  @doc """
  Returns the list of transactions from account.

  ## Examples

      iex> list_transactions_from_account(account_id)
      [%Transaction{}, ...]

  """
  def list_transactions_from_account(account_id) do
    Repo.all(from t in Transaction, where: t.account_id == ^account_id, order_by: [desc: t.date])
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id) |> Repo.preload([:type, :category])

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}) do
    account_balance = Accounts.get_account!(attrs["account_id"]).balance

    attrs =
      attrs
      |> Map.put("account_balance", account_balance)

    case %Transaction{} |> Transaction.changeset(attrs) |> Repo.insert() do
      {:ok, transaction} ->
        Accounts.update_balance(:insert, transaction)
        {:ok, transaction |> Repo.preload([:type, :category])}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%Transaction{} = transaction, attrs) do
    case transaction |> Transaction.changeset(attrs) |> Repo.update() do
      {:ok, transaction} ->
        Accounts.update_balance(:edit, transaction)
        {:ok, transaction |> Repo.preload([:type, :category])}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    {:ok, transaction} = Repo.delete(transaction)
    Accounts.update_balance(:delete, transaction)
    {:ok, transaction |> Repo.preload([:type, :category])}
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{data: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, attrs)
  end
end

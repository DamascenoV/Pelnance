defmodule Pelnance.Types do
  @moduledoc """
  The Types context.
  """

  import Ecto.Query, warn: false
  alias Pelnance.Repo

  alias Pelnance.Types.Type
  alias Pelnance.Users.User

  @doc """
  Returns the list of types.

  ## Examples

      iex> list_types(%User{})
      [%Type{}, ...]

  """
  def list_types(user = %User{}) do
    Repo.all(from t in Type, where: t.user_id == ^user.id)
  end

  @doc """
  Gets a single type.

  Raises `Ecto.NoResultsError` if the Type does not exist.

  ## Examples

      iex> get_type!(123)
      %Type{}

      iex> get_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_type!(id), do: Repo.get!(Type, id)

  @doc """
  Creates a type.

  ## Examples

      iex> create_type(%User{}, %{field: value})
      {:ok, %Type{}}

      iex> create_type(%User{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_type(user = %User{}, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:types)
    |> Type.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a type.

  ## Examples

      iex> update_type(type, %{field: new_value})
      {:ok, %Type{}}

      iex> update_type(type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_type(%Type{} = type, attrs) do
    type
    |> Type.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a type.

  ## Examples

      iex> delete_type(type)
      {:ok, %Type{}}

      iex> delete_type(type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_type(%Type{} = type) do
    Repo.delete(type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking type changes.

  ## Examples

      iex> change_type(type)
      %Ecto.Changeset{data: %Type{}}

  """
  def change_type(%Type{} = type, attrs \\ %{}) do
    Type.changeset(type, attrs)
  end
end

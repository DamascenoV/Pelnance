defmodule Pelnance.Categories do
  @moduledoc """
  The Categories context.
  """

  import Ecto.Query, warn: false
  alias Pelnance.Repo

  alias Pelnance.Users.User
  alias Pelnance.Categories.Category
  alias Flop

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories(%User{})
      [%Category{}, ...]

  """
  def list_categories(user = %User{}, params) do
    Category
    |> where(user_id: ^user.id)
    |> preload([:type])
    |> Flop.validate_and_run(params, for: Category)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id) |> Repo.preload([:type])

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%User{}, %{field: value})
      {:ok, %Category{}}

      iex> create_category(%User{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(user = %User{}, attrs \\ %{}) do
    category =
      user
      |> Ecto.build_assoc(:categories)
      |> Category.changeset(attrs)
      |> Repo.insert()

    case category do
      {:ok, category} -> {:ok, category |> Repo.preload([:type])}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    case category |> Category.changeset(attrs) |> Repo.update() do
      {:ok, category} -> {:ok, category |> Repo.preload([:type])}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  Deletes a category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{data: %Category{}}

  """
  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end
end

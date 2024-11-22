defmodule Pelnance.CategoriesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pelnance.Categories` context.
  """

  @doc """
  Generate a category.
  """
  def category_fixture(user, attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        name: "some name"
      })

    {:ok, category} =
      Pelnance.Categories.create_category(user, attrs)

    category
  end
end

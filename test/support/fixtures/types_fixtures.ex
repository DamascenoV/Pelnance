defmodule Pelnance.TypesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pelnance.Types` context.
  """

  @doc """
  Generate a type.
  """
  def type_fixture(attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        name: "some name",
        subtraction: true
      })

    {:ok, type} =
      Pelnance.Types.create_type(attrs)

    type
  end
end

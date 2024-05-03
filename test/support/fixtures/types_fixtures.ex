defmodule Pelnance.TypesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pelnance.Types` context.
  """

  @doc """
  Generate a type.
  """
  def type_fixture(attrs \\ %{}) do
    {:ok, type} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Pelnance.Types.create_type()

    type
  end
end

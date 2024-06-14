defmodule Pelnance.TypesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pelnance.Types` context.
  """

  @doc """
  Generate a type.
  """
  def type_fixture(user = %Pelnance.Users.User{}, attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        name: "some name",
        icon: "hero-icon",
        subtraction: true
      })

    {:ok, type} =
      Pelnance.Types.create_type(user, attrs)

    type
  end
end

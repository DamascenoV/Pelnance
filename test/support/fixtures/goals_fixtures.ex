defmodule Pelnance.GoalsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pelnance.Goals` context.
  """

  @doc """
  Generate a goal.
  """
  def goal_fixture(user = %Pelnance.Users.User{}, attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        done: true,
        name: "some name",
        description: "some description"
      })

    {:ok, goal} =
      Pelnance.Goals.create_goal(user, attrs)

    goal
  end
end

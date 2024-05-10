defmodule Pelnance.GoalsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pelnance.Goals` context.
  """

  @doc """
  Generate a goal.
  """
  def goal_fixture(attrs \\ %{}) do
    {:ok, goal} =
      attrs
      |> Enum.into(%{
        done: true,
        name: "some name"
      })
      |> Pelnance.Goals.create_goal()

    goal
  end
end

defmodule Pelnance.GoalsTest do
  use Pelnance.DataCase

  alias Pelnance.Goals

  describe "goals" do
    alias Pelnance.Goals.Goal

    import Pelnance.GoalsFixtures

    @invalid_attrs %{name: nil, done: nil}

    test "list_goals/0 returns all goals" do
      goal = goal_fixture()
      assert Goals.list_goals() == [goal]
    end

    test "get_goal!/1 returns the goal with given id" do
      goal = goal_fixture()
      assert Goals.get_goal!(goal.id) == goal
    end

    test "create_goal/1 with valid data creates a goal" do
      valid_attrs = %{name: "some name", done: true}

      assert {:ok, %Goal{} = goal} = Goals.create_goal(valid_attrs)
      assert goal.name == "some name"
      assert goal.done == true
    end

    test "create_goal/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Goals.create_goal(@invalid_attrs)
    end

    test "update_goal/2 with valid data updates the goal" do
      goal = goal_fixture()
      update_attrs = %{name: "some updated name", done: false}

      assert {:ok, %Goal{} = goal} = Goals.update_goal(goal, update_attrs)
      assert goal.name == "some updated name"
      assert goal.done == false
    end

    test "update_goal/2 with invalid data returns error changeset" do
      goal = goal_fixture()
      assert {:error, %Ecto.Changeset{}} = Goals.update_goal(goal, @invalid_attrs)
      assert goal == Goals.get_goal!(goal.id)
    end

    test "delete_goal/1 deletes the goal" do
      goal = goal_fixture()
      assert {:ok, %Goal{}} = Goals.delete_goal(goal)
      assert_raise Ecto.NoResultsError, fn -> Goals.get_goal!(goal.id) end
    end

    test "change_goal/1 returns a goal changeset" do
      goal = goal_fixture()
      assert %Ecto.Changeset{} = Goals.change_goal(goal)
    end
  end
end

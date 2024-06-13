defmodule Pelnance.GoalsTest do
  use Pelnance.DataCase

  alias Pelnance.Goals

  describe "goals" do
    alias Pelnance.Goals.Goal

    import Pelnance.GoalsFixtures
    import Pelnance.UsersFixtures

    @invalid_attrs %{name: nil, done: nil}

    test "list_goals/0 returns all goals" do
      user = user_fixture()
      goal = goal_fixture(user)
      assert Goals.list_goals(user) == [goal]
    end

    test "get_goal!/1 returns the goal with given id" do
      user = user_fixture()
      goal = goal_fixture(user)
      assert Goals.get_goal!(goal.id) == goal
    end

    test "create_goal/1 with valid data creates a goal" do
      user = user_fixture()
      valid_attrs = %{name: "some name", description: "some description", done: true}

      assert {:ok, %Goal{} = goal} = Goals.create_goal(user, valid_attrs)
      assert goal.name == "some name"
      assert goal.done == true
      assert goal.user_id == user.id
    end

    test "create_goal/1 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Goals.create_goal(user, @invalid_attrs)
    end

    test "update_goal/2 with valid data updates the goal" do
      user = user_fixture()
      goal = goal_fixture(user)
      update_attrs = %{name: "some updated name", done: false}

      assert {:ok, %Goal{} = goal} = Goals.update_goal(goal, update_attrs)
      assert goal.name == "some updated name"
      assert goal.done == false
    end

    test "update_goal/2 with invalid data returns error changeset" do
      user = user_fixture()
      goal = goal_fixture(user)
      assert {:error, %Ecto.Changeset{}} = Goals.update_goal(goal, @invalid_attrs)
      assert goal == Goals.get_goal!(goal.id)
    end

    test "delete_goal/1 deletes the goal" do
      user = user_fixture()
      goal = goal_fixture(user)
      assert {:ok, %Goal{}} = Goals.delete_goal(goal)
      assert_raise Ecto.NoResultsError, fn -> Goals.get_goal!(goal.id) end
    end

    test "change_goal/1 returns a goal changeset" do
      user = user_fixture()
      goal = goal_fixture(user)
      assert %Ecto.Changeset{} = Goals.change_goal(goal)
    end
  end
end

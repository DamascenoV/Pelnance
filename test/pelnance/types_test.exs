defmodule Pelnance.TypesTest do
  use Pelnance.DataCase

  alias Pelnance.Types

  describe "types" do
    alias Pelnance.Types.Type

    import Pelnance.TypesFixtures
    import Pelnance.UsersFixtures

    @invalid_attrs %{name: nil, subtraction: false}

    test "list_types/0 returns all types" do
      user = user_fixture()
      type = type_fixture(user)
      assert Types.list_types(user) == [type]
    end

    test "get_type!/1 returns the type with given id" do
      user = user_fixture()
      type = type_fixture(user)
      assert Types.get_type!(type.id) == type
    end

    test "create_type/1 with valid data creates a type" do
      user = user_fixture()
      valid_attrs = %{name: "some name", subtraction: true}

      assert {:ok, %Type{} = type} = Types.create_type(user, valid_attrs)
      assert type.name == "some name"
      assert type.subtraction == true
      assert type.user_id == user.id
    end

    test "create_type/1 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Types.create_type(user, @invalid_attrs)
    end

    test "update_type/2 with valid data updates the type" do
      user = user_fixture()
      type = type_fixture(user)
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Type{} = type} = Types.update_type(type, update_attrs)
      assert type.name == "some updated name"
    end

    test "update_type/2 with invalid data returns error changeset" do
      user = user_fixture()
      type = type_fixture(user)
      assert {:error, %Ecto.Changeset{}} = Types.update_type(type, @invalid_attrs)
      assert type == Types.get_type!(type.id)
    end

    test "delete_type/1 deletes the type" do
      user = user_fixture()
      type = type_fixture(user)
      assert {:ok, %Type{}} = Types.delete_type(type)
      assert_raise Ecto.NoResultsError, fn -> Types.get_type!(type.id) end
    end

    test "change_type/1 returns a type changeset" do
      user = user_fixture()
      type = type_fixture(user)
      assert %Ecto.Changeset{} = Types.change_type(type)
    end
  end
end

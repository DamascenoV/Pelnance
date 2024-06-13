defmodule Pelnance.CategoriesTest do
  use Pelnance.DataCase

  alias Pelnance.Categories

  describe "categories" do
    alias Pelnance.Categories.Category

    import Pelnance.CategoriesFixtures
    import Pelnance.UsersFixtures
    import Pelnance.TypesFixtures

    @invalid_attrs %{name: nil}

    test "list_categories/0 returns all categories" do
      user = user_fixture()
      type = type_fixture(user)
      category = category_fixture(user, %{type_id: type.id})
      assert Categories.list_categories(user) == [category]
    end

    test "get_category!/1 returns the category with given id" do
      user = user_fixture()
      type = type_fixture(user)
      category = category_fixture(user, %{type_id: type.id})
      assert Categories.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      user = user_fixture()
      type = type_fixture(user)
      valid_attrs = %{name: "some name", type_id: type.id}

      assert {:ok, %Category{} = category} = Categories.create_category(user, valid_attrs)
      assert category.name == "some name"
      assert category.type_id == type.id
      assert category.user_id == user.id
    end

    test "create_category/1 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Categories.create_category(user, @invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      user = user_fixture()
      type = type_fixture(user)
      category = category_fixture(user, %{type_id: type.id})
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Category{} = category} = Categories.update_category(category, update_attrs)
      assert category.name == "some updated name"
    end

    test "update_category/2 with invalid data returns error changeset" do
      user = user_fixture()
      type = type_fixture(user)
      category = category_fixture(user, %{type_id: type.id})
      assert {:error, %Ecto.Changeset{}} = Categories.update_category(category, @invalid_attrs)
      assert category == Categories.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      user = user_fixture()
      type = type_fixture(user)
      category = category_fixture(user, %{type_id: type.id})
      assert {:ok, %Category{}} = Categories.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Categories.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      user = user_fixture()
      type = type_fixture(user)
      category = category_fixture(user, %{type_id: type.id})
      assert %Ecto.Changeset{} = Categories.change_category(category)
    end
  end
end

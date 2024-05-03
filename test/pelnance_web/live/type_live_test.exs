defmodule PelnanceWeb.TypeLiveTest do
  use PelnanceWeb.ConnCase

  import Phoenix.LiveViewTest
  import Pelnance.TypesFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_type(_) do
    type = type_fixture()
    %{type: type}
  end

  describe "Index" do
    setup [:create_type]

    test "lists all types", %{conn: conn, type: type} do
      {:ok, _index_live, html} = live(conn, ~p"/types")

      assert html =~ "Listing Types"
      assert html =~ type.name
    end

    test "saves new type", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/types")

      assert index_live |> element("a", "New Type") |> render_click() =~
               "New Type"

      assert_patch(index_live, ~p"/types/new")

      assert index_live
             |> form("#type-form", type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#type-form", type: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/types")

      html = render(index_live)
      assert html =~ "Type created successfully"
      assert html =~ "some name"
    end

    test "updates type in listing", %{conn: conn, type: type} do
      {:ok, index_live, _html} = live(conn, ~p"/types")

      assert index_live |> element("#types-#{type.id} a", "Edit") |> render_click() =~
               "Edit Type"

      assert_patch(index_live, ~p"/types/#{type}/edit")

      assert index_live
             |> form("#type-form", type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#type-form", type: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/types")

      html = render(index_live)
      assert html =~ "Type updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes type in listing", %{conn: conn, type: type} do
      {:ok, index_live, _html} = live(conn, ~p"/types")

      assert index_live |> element("#types-#{type.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#types-#{type.id}")
    end
  end

  describe "Show" do
    setup [:create_type]

    test "displays type", %{conn: conn, type: type} do
      {:ok, _show_live, html} = live(conn, ~p"/types/#{type}")

      assert html =~ "Show Type"
      assert html =~ type.name
    end

    test "updates type within modal", %{conn: conn, type: type} do
      {:ok, show_live, _html} = live(conn, ~p"/types/#{type}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Type"

      assert_patch(show_live, ~p"/types/#{type}/show/edit")

      assert show_live
             |> form("#type-form", type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#type-form", type: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/types/#{type}")

      html = render(show_live)
      assert html =~ "Type updated successfully"
      assert html =~ "some updated name"
    end
  end
end

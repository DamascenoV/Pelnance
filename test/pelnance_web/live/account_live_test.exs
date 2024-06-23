defmodule PelnanceWeb.AccountLiveTest do
  use PelnanceWeb.ConnCase

  import Phoenix.LiveViewTest
  import Pelnance.UsersFixtures
  import Pelnance.CurrenciesFixtures
  import Pelnance.AccountsFixtures

  @update_attrs %{name: "some updated name", balance: "456.7"}
  @invalid_attrs %{name: nil, balance: nil}

  defp create_account(_) do
    user = user_fixture()

    currency = currency_fixture(user)
    account = account_fixture(user, %{currency_id: currency.id})
    %{account: account, user: user}
  end

  describe "Index" do
    setup [:create_account]

    test "lists all accounts", %{conn: conn, account: account, user: user} do
      {:ok, _index_live, html} = live(conn |> log_in_user(user), ~p"/accounts")

      assert html =~ "Listing Accounts"
      assert html =~ account.name
    end

    test "saves new account", %{conn: conn, user: user} do
      {:ok, index_live, _html} = live(conn |> log_in_user(user), ~p"/accounts")

      currency = currency_fixture(user)

      assert index_live |> element("a", "New Account") |> render_click() =~
               "New Account"

      assert_patch(index_live, ~p"/accounts/new")

      assert index_live
             |> form("#account-form",
               account: %{balance: nil, name: nil}
             )
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#account-form",
               account: %{
                 balance: Decimal.new("1000"),
                 name: "Account_Test",
                 currency_id: [currency.id]
               }
             )
             |> render_submit()

      assert_patch(index_live, ~p"/accounts")

      html = render(index_live)
      assert html =~ "Account created successfully"
      assert html =~ "some name"
    end

    test "updates account in listing", %{conn: conn, account: account, user: user} do
      {:ok, index_live, _html} = live(conn |> log_in_user(user), ~p"/accounts")

      assert index_live |> element("#accounts-#{account.id} a", "Edit") |> render_click() =~
               "Edit Account"

      assert_patch(index_live, ~p"/accounts/#{account}/edit")

      assert index_live
             |> form("#account-form", account: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#account-form", account: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/accounts")

      html = render(index_live)
      assert html =~ "Account updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes account in listing", %{conn: conn, account: account, user: user} do
      {:ok, index_live, _html} = live(conn |> log_in_user(user), ~p"/accounts")

      assert index_live |> element("#accounts-#{account.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#accounts-#{account.id}")
    end
  end

  describe "Show" do
    setup [:create_account]

    test "displays account", %{conn: conn, account: account, user: user} do
      {:ok, _show_live, html} = live(conn |> log_in_user(user), ~p"/accounts/#{account}")

      assert html =~ "Show Account"
      assert html =~ account.name
    end

    test "updates account within modal", %{conn: conn, account: account, user: user} do
      {:ok, show_live, _html} = live(conn |> log_in_user(user), ~p"/accounts/#{account}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Account"

      assert_patch(show_live, ~p"/accounts/#{account}/show/edit")

      assert show_live
             |> form("#account-form", account: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#account-form", account: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/accounts/#{account}")

      html = render(show_live)
      assert html =~ "Account updated successfully"
      assert html =~ "some updated name"
    end
  end
end

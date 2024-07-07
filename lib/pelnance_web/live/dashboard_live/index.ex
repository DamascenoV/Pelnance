defmodule PelnanceWeb.DashboardLive.Index do
  use PelnanceWeb, :live_view

  alias Pelnance.Users

  @impl true
  def mount(_params, _session, socket) do
    user = Users.prepare_user(socket.assigns.current_user)
    transactions = Pelnance.Transactions.list_transactions(user)

    step_number =
      Enum.count([user.currencies, user.types, user.categories, user.accounts], fn x ->
        !Enum.empty?(x)
      end)

    accounts_info = %{
      total_balance:
        Enum.reduce(user.accounts, 0, fn x, acc -> acc + Decimal.to_float(x.balance) end),
      total_accounts: Enum.count(user.accounts),
      total_currencies: Enum.count(user.currencies)
    }

    transactions_info = %{
      total: Enum.reduce(transactions, 0, fn transaction, acc -> acc + Decimal.to_float(transaction.amount) end),
      total_expenses: Enum.count(transactions, fn x -> x.type.subtraction == true end),
      total_income: Enum.count(transactions, fn x -> x.type.subtraction == false end),
    }

    {
      :ok,
      socket
      |> assign(:user, user)
      |> assign(:step_number, step_number)
      |> assign(:accounts_info, accounts_info)
      |> assign(:transactions_info, transactions_info)
    }
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("create_currency", _params, socket) do
    {:noreply, push_patch(socket, to: ~p"/dashboard/new_currency")}
  end

  @impl true
  def handle_event("create_type", _params, socket) do
    {:noreply, push_patch(socket, to: ~p"/dashboard/new_type")}
  end

  @impl true
  def handle_event("create_category", _params, socket) do
    {:noreply, push_patch(socket, to: ~p"/dashboard/new_category")}
  end

  @impl true
  def handle_event("create_account", _params, socket) do
    {:noreply, push_patch(socket, to: ~p"/dashboard/new_account")}
  end

  def handle_event("generate", _params, socket) do
    Pelnance.Types.generate_types(socket.assigns.current_user)

    socket =
      socket
      |> assign(socket, user: Users.prepare_user(socket.assigns.current_user))
      |> put_flash(:info, gettext("Types generated successfully"))

    {:noreply, socket}
  end

  @impl true
  def handle_info({_, {:saved, _}}, socket) do
    socket =
      socket
      |> assign(step_number: socket.assigns.step_number + 1)
      |> assign(user: Users.prepare_user(socket.assigns.current_user))

    {:noreply, socket}
  end
end

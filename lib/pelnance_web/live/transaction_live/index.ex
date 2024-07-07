defmodule PelnanceWeb.TransactionLive.Index do
  use PelnanceWeb, :live_view

  alias Pelnance.Transactions
  alias Pelnance.Accounts
  alias Pelnance.Categories
  alias Pelnance.Transactions.Transaction

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <%= gettext("Listing Transactions") %> <.icon name="hero-arrows-right-left" />
      <:actions>
        <%= for type <- Pelnance.Types.list_types(@current_user) do %>
          <.link patch={~p"/transactions/new?type=#{type.id}"}>
            <.button class="text-xs"><%= gettext("New") %> <%= type.name %></.button>
          </.link>
        <% end %>
      </:actions>
    </.header>

    <!-- <.simple_form for={} phx-change="filter-description">
       <div class="grid grid-cols-8 gap-4">
         <.input type="select" options={[]} name="type" value={nil} label={gettext("Type")} />
         <.input type="select" options={[]} name="account" value={nil} label={gettext("Account")} />
         <.input type="select" options={[]} name="category" value={nil} label={gettext("Type")} />
         <.input type="text" name="description" value={nil} label={gettext("Description")} />
         <.input type="number" step="0.01" name="amount" value={nil} label={gettext("Amount")} />
         <.input type="date" name="start" value={nil} label={gettext("Start")} />
         <.input type="date" name="end" value={nil} label={gettext("End")} />
       </div>
    </.simple_form> -->

    <.table id="transactions" rows={@streams.transactions}>
      <:col :let={{_id, transaction}} label={gettext("Type")}>
        <%= if transaction.type.subtraction == true do %>
          <.icon name="hero-arrow-trending-down text-red-500" />
        <% else %>
          <.icon name="hero-arrow-trending-up text-green-500" />
        <% end %>
        - <%= transaction.type.name %>
      </:col>
      <:col :let={{_id, transaction}} label={gettext("Account")}>
        <%= transaction.account.name %>
      </:col>
      <:col :let={{_id, transaction}} label={gettext("Category")}>
        <%= transaction.category.name %>
      </:col>
      <:col :let={{_id, transaction}} label={gettext("Description")}>
        <%= transaction.description %>
      </:col>
      <:col :let={{_id, transaction}} label={gettext("Amount")}><%= transaction.amount %> €</:col>
      <:col :let={{_id, transaction}} label={gettext("Balance")}>
        <%= transaction.account_balance %> €
      </:col>
      <:col :let={{_id, transaction}} label={gettext("Date")}><%= transaction.date %></:col>
      <:action :let={{id, transaction}}>
        <.link navigate={~p"/transactions/#{transaction}"}>
          <.icon name="hero-eye" />
        </.link>
        <.link patch={~p"/transactions/#{transaction}/edit?type=#{transaction.type_id}"}>
          <.icon name="hero-pencil-square" />
        </.link>
        <.link
          phx-click={JS.push("delete", value: %{id: transaction.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          <.icon name="hero-trash" class="text-red-700" />
        </.link>
      </:action>
    </.table>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="transaction-modal"
      show
      on_cancel={JS.patch(~p"/transactions")}
    >
      <.live_component
        module={PelnanceWeb.TransactionLive.FormComponent}
        id={@transaction.id || :new}
        title={@page_title}
        action={@live_action}
        transaction={@transaction}
        type_id={@type_id}
        categories={@categories}
        current_user={@current_user}
        accounts={@accounts}
        patch={~p"/transactions"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> stream(:transactions, Transactions.list_transactions(socket.assigns.current_user))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, params) do
    IO.inspect(params)

    socket
    |> assign(:page_title, gettext("Edit Transaction"))
    |> assign(:transaction, Transactions.get_transaction!(params["id"]))
    |> assign(:accounts, Accounts.list_accounts(socket.assigns.current_user))
    |> assign(
      :categories,
      Categories.list_categories(socket.assigns.current_user)
      |> Enum.filter(&(&1.type_id == params["type"]))
    )
    |> assign(:type_id, params["type"])
  end

  defp apply_action(socket, :new, params) do
    socket
    |> assign(:page_title, gettext("New Transaction"))
    |> assign(:transaction, %Transaction{})
    |> assign(:accounts, Accounts.list_accounts(socket.assigns.current_user))
    |> assign(
      :categories,
      Categories.list_categories(socket.assigns.current_user)
      |> Enum.filter(&(&1.type_id == params["type"]))
    )
    |> assign(:type_id, params["type"])
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, gettext("Listing Transactions"))
    |> assign(:transaction, nil)
  end

  @impl true
  def handle_info({PelnanceWeb.TransactionLive.FormComponent, {:saved, transaction}}, socket) do
    {:noreply, stream_insert(socket, :transactions, transaction)}
  end

  # @impl true
  # def handle_event("filter-description", filters, socket) do
  #   dbg(filters)
  #
  #   transactions = Transactions.list_transactions(socket.assigns.current_user)
  #
  #   filter_transactions =
  #     Enum.filter(transactions, fn transaction -> transaction.description == filters["description"] end)
  #
  #   dbg(filter_transactions)
  #
  #   {:noreply,
  #    stream(
  #      socket,
  #      :transactions,
  #      filter_transactions
  #    )}
  # end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    transaction = Transactions.get_transaction!(id)
    {:ok, _} = Transactions.delete_transaction(transaction)

    {:noreply, stream_delete(socket, :transactions, transaction)}
  end
end

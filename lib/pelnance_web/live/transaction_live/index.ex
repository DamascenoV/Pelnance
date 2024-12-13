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
        <%= for type <- Pelnance.Types.list_types() do %>
          <.link patch={~p"/transactions/new?type=#{type.id}"}>
            <.button class="text-xs">
              <%= gettext("New") %> <%= Gettext.gettext(PelnanceWeb.Gettext, type.name) %>
            </.button>
          </.link>
        <% end %>
      </:actions>
    </.header>

    <.filter_form
      id="transaction_filter"
      fields={[
        type_name: [
          label: gettext("Type"),
          op: :like,
          type: "text"
        ],
        account_name: [
          label: gettext("Account"),
          op: :like,
          type: "text"
        ],
        category_name: [
          label: gettext("Category"),
          op: :like,
          type: "text"
        ],
        description: [
          label: gettext("Description"),
          op: :like,
          type: "text"
        ],
        date: [
          label: gettext("Date"),
          op: :==,
          type: "date"
        ]
      ]}
      meta={@meta}
    />

    <Flop.Phoenix.table items={@streams.transactions} meta={@meta} path={~p"/transactions"}>
      <:col :let={{_id, transaction}} label={gettext("Type")} field={:type_name}>
        <%= if transaction.type.subtraction == true do %>
          <.icon name="hero-arrow-trending-down text-red-500" />
        <% else %>
          <.icon name="hero-arrow-trending-up text-green-500" />
        <% end %>
        - <%= transaction.type.name %>
      </:col>
      <:col :let={{_id, transaction}} label={gettext("Account")} field={:account_name}>
        <%= transaction.account.name %>
      </:col>
      <:col :let={{_id, transaction}} label={gettext("Category")} field={:category_name}>
        <%= transaction.category.name %>
      </:col>
      <:col :let={{_id, transaction}} label={gettext("Description")} field={:description}>
        <%= transaction.description %>
      </:col>
      <:col :let={{_id, transaction}} label={gettext("Amount")} field={:amount}>
        <%= transaction.amount %> €
      </:col>
      <:col :let={{_id, transaction}} label={gettext("Balance")} field={:account_balance}>
        <%= transaction.account_balance %> €
      </:col>
      <:col :let={{_id, transaction}} label={gettext("Date")} field={:date}>
        <%= transaction.date %>
      </:col>
      <:col :let={{id, transaction}} label={gettext("Actions")}>
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
      </:col>
    </Flop.Phoenix.table>

    <Flop.Phoenix.pagination meta={@meta} path={~p"/transactions"} />

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
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, params) do
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

  defp apply_action(socket, :index, params) do
    case Transactions.list_transactions(socket.assigns.current_user, params) do
      {:ok, {transactions, meta}} ->
        socket
        |> assign(:page_title, gettext("Listing Transactions"))
        |> assign(:meta, meta)
        |> stream(:transactions, transactions, reset: true)

      {:error, meta} ->
        IO.inspect(meta.errors, label: "AQUI")
        redirect(socket, to: ~p"/transactions")
    end
  end

  @impl true
  def handle_info({PelnanceWeb.TransactionLive.FormComponent, {:saved, transaction}}, socket) do
    {:noreply, stream_insert(socket, :transactions, transaction)}
  end

  @impl true
  def handle_event("update-filter", params, socket) do
    params = Map.delete(params, "_target")
    {:noreply, apply_action(socket, :index, params)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    transaction = Transactions.get_transaction!(id)
    {:ok, _} = Transactions.delete_transaction(transaction)

    {:noreply, stream_delete(socket, :transactions, transaction)}
  end
end

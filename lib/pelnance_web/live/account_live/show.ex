defmodule PelnanceWeb.AccountLive.Show do
  use PelnanceWeb, :live_view

  alias Pelnance.Accounts
  alias Pelnance.Transactions
  alias Pelnance.Currencies

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <%= gettext("Account") %> <%= @account.name %>
      <:actions>
        <.link patch={~p"/accounts/#{@account}/show/edit"} phx-click={JS.push_focus()}>
          <.button><%= "Edit account" %></.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title={gettext("Name")}><%= @account.name %></:item>
      <:item title={gettext("Balance")}><%= @account.balance %></:item>
      <:item title={gettext("Currency")}>
        <%= Pelnance.Currencies.get_currency!(@account.currency_id).name %>
      </:item>
    </.list>

    <.back navigate={~p"/accounts"}><%= gettext("Back to accounts") %></.back>

    <hr class="my-5" />

    <.header class="mt-5">
      Transactions
    </.header>

    <.table id="transactions" rows={@streams.transactions}>
      <:col :let={{_id, transaction}} label={gettext("Type")}>
        <.icon name={Pelnance.Types.get_type!(transaction.type_id).icon} />
        - <%= Pelnance.Types.get_type!(transaction.type_id).name %>
      </:col>
      <:col :let={{_id, transaction}} label={gettext("Category")}>
        <%= Pelnance.Categories.get_category!(transaction.category_id).name %>
      </:col>
      <:col :let={{_id, transaction}} label={gettext("Description")}>
        <%= transaction.description %>
      </:col>
      <:col :let={{_id, transaction}} label={gettext("Amount")}><%= transaction.amount %></:col>
      <:col :let={{_id, transaction}} label={gettext("Date")}><%= transaction.date %></:col>
    </.table>

    <.back navigate={~p"/transactions"}>Go to transactions</.back>

    <.modal
      :if={@live_action == :edit}
      id="account-modal"
      show
      on_cancel={JS.patch(~p"/accounts/#{@account}")}
    >
      <.live_component
        module={PelnanceWeb.AccountLive.FormComponent}
        id={@account.id}
        title={@page_title}
        action={@live_action}
        currencies={@currencies}
        account={@account}
        patch={~p"/accounts/#{@account}"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    IO.inspect(params)

    {:ok,
     socket
     |> stream(:transactions, Transactions.list_transactions_from_account(params["id"]),
       at: 0,
       limit: 2
     )
     |> assign(:currencies, Currencies.list_currencies(socket.assigns.current_user))}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:account, Accounts.get_account!(id))}
  end

  defp page_title(:show), do: gettext("Show Account")
  defp page_title(:edit), do: gettext("Edit Account")
end

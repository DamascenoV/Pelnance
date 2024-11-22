defmodule PelnanceWeb.AccountLive.Index do
  use PelnanceWeb, :live_view

  alias Pelnance.Accounts
  alias Pelnance.Accounts.Account
  alias Pelnance.Currencies

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <%= gettext("Listing Accounts") %> <.icon name="hero-wallet" />
      <:actions>
        <.link patch={~p"/accounts/new"}>
          <.button><%= gettext("New Account") %></.button>
        </.link>
      </:actions>
    </.header>

    <.filter_form
      fields={[
        name: [
          label: gettext("Name"),
          op: :like,
          type: "text"
        ],
        balance: [
          label: gettext("Balance"),
          op: :==,
          type: "number"
        ]
      ]}
      meta={@meta}
    />

    <Flop.Phoenix.table items={@streams.accounts} meta={@meta} path={~p"/accounts"}>
      <:col :let={{_id, account}} field={:name} label={gettext("Name")}><%= account.name %></:col>
      <:col :let={{_id, account}} field={:balance} label={gettext("Balance")}>
        <%= account.balance %> <%= account.currency.symbol %>
      </:col>
      <:col :let={{_id, account}} label={gettext("Currency")}>
        <%= Pelnance.Currencies.get_currency!(account.currency_id).name %>
      </:col>
      <:col :let={{id, account}}>
        <.link navigate={~p"/accounts/#{account}"}>
          <.icon name="hero-eye" />
        </.link>
        <.link patch={~p"/accounts/#{account}/edit"}>
          <.icon name="hero-pencil-square" />
        </.link>
        <.link
          phx-click={JS.push("delete", value: %{id: account.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          <.icon name="hero-trash" class="text-red-700" />
        </.link>
      </:col>
    </Flop.Phoenix.table>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="account-modal"
      show
      on_cancel={JS.patch(~p"/accounts")}
    >
      <.live_component
        module={PelnanceWeb.AccountLive.FormComponent}
        id={@account.id || :new}
        title={@page_title}
        action={@live_action}
        account={@account}
        currencies={@currencies}
        current_user={@user}
        patch={~p"/accounts"}
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
    |> assign(:page_title, gettext("Edit Account"))
    |> assign(:account, Accounts.get_account!(params["id"]))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, gettext("New Account"))
    |> assign(:account, %Account{})
  end

  defp apply_action(socket, :index, params) do
    case Accounts.list_accounts(socket.assigns.current_user, params) do
      {:ok, {accounts, meta}} ->
        socket
        |> assign(:page_title, gettext("Listing Accounts"))
        |> assign(:currencies, Currencies.list_currencies(socket.assigns.current_user))
        |> assign(:user, socket.assigns.current_user)
        |> assign(:meta, meta)
        |> stream(:accounts, accounts, reset: true)

      {:error, _meta} ->
        redirect(socket, to: ~p"/accounts")
    end
  end

  @impl true
  def handle_info({PelnanceWeb.AccountLive.FormComponent, {:saved, account}}, socket) do
    {:noreply, stream_insert(socket, :accounts, account)}
  end

  @impl true
  def handle_event("update-filter", params, socket) do
    params = Map.delete(params, "_target")
    {:noreply, apply_action(socket, :index, params)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    account = Accounts.get_account!(id)
    {:ok, _} = Accounts.delete_account(account)

    {:noreply, stream_delete(socket, :accounts, account)}
  end
end

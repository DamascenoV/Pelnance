defmodule PelnanceWeb.CurrencyLive.Index do
  use PelnanceWeb, :live_view

  alias Pelnance.Currencies
  alias Pelnance.Currencies.Currency

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <%= gettext("Listing Currencies") %> <.icon name="hero-currency-euro " />
      <:actions>
        <.link patch={~p"/currencies/new"}>
          <.button><%= gettext("New Currency") %></.button>
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
        symbol: [
          label: gettext("Symbol"),
          op: :like,
          type: "text"
        ]
      ]}
      meta={@meta}
    />

    <Flop.Phoenix.table
      items={@streams.currencies}
      meta={@meta}
      path={~p"/currencies"}
      opts={[
        table_attrs: [class: "table table-sm table-zebra"],
        tbody_td_attrs: [class: "cursor-pointer"]
      ]}
    >
      <:col :let={{_id, currency}} label={gettext("Name")} field={:name}><%= currency.name %></:col>
      <:col :let={{_id, currency}} label={gettext("Symbol")} field={:symbol}>
        <%= currency.symbol %>
      </:col>
      <:col :let={{id, currency}} label={gettext("Actions")}>
        <.link navigate={~p"/currencies/#{currency}"}>
          <.icon name="hero-eye" />
        </.link>
        <.link patch={~p"/currencies/#{currency}/edit"}>
          <span class="hidden">Edit</span>
          <.icon name="hero-pencil-square" />
        </.link>
        <.link
          phx-click={JS.push("delete", value: %{id: currency.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          <span class="hidden">Delete</span>
          <.icon name="hero-trash" class="text-red-700" />
        </.link>
      </:col>
    </Flop.Phoenix.table>

    <Flop.Phoenix.pagination meta={@meta} path={~p"/currencies"} />

    <.modal
      :if={@live_action in [:new, :edit]}
      id="currency-modal"
      show
      on_cancel={JS.patch(~p"/currencies")}
    >
      <.live_component
        module={PelnanceWeb.CurrencyLive.FormComponent}
        id={@currency.id || :new}
        title={@page_title}
        action={@live_action}
        currency={@currency}
        current_user={@current_user}
        patch={~p"/currencies"}
      />
    </.modal>
    """
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, gettext("Edit Currency"))
    |> assign(:currency, Currencies.get_currency!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, gettext("New Currency"))
    |> assign(:currency, %Currency{})
    |> assign(:current_user, socket.assigns.current_user)
  end

  defp apply_action(socket, :index, params) do
    case Currencies.list_currencies(socket.assigns.current_user, params) do
      {:ok, {currencies, meta}} ->
        socket
        |> stream(:currencies, currencies, reset: true)
        |> assign(:page_title, gettext("Listing Currencies"))
        |> assign(:meta, meta)

      {:error, _meta} ->
        redirect(socket, to: ~p"/currencies")
    end
  end

  @impl true
  def handle_info({PelnanceWeb.CurrencyLive.FormComponent, {:saved, currency}}, socket) do
    {:noreply, stream_insert(socket, :currencies, currency)}
  end

  @impl true
  def handle_event("update-filter", params, socket) do
    params = Map.delete(params, "_target")
    {:noreply, apply_action(socket, :index, params)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    currency = Currencies.get_currency!(id)
    {:ok, _} = Currencies.delete_currency(currency)

    {:noreply, stream_delete(socket, :currencies, currency)}
  end
end

defmodule PelnanceWeb.CurrencyLive.Show do
  use PelnanceWeb, :live_view

  alias Pelnance.Currencies

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <%= gettext("Currency") %> Currency <%= @currency.id %>
      <:actions>
        <.link patch={~p"/currencies/#{@currency}/show/edit"} phx-click={JS.push_focus()}>
          <.button><%= "Edit currency" %></.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title={gettext("Name")}><%= @currency.name %></:item>
      <:item title={gettext("Symbol")}><%= @currency.symbol %></:item>
    </.list>

    <.back navigate={~p"/currencies"}><%= gettext("Back to currencies") %></.back>

    <.modal
      :if={@live_action == :edit}
      id="currency-modal"
      show
      on_cancel={JS.patch(~p"/currencies/#{@currency}")}
    >
      <.live_component
        module={PelnanceWeb.CurrencyLive.FormComponent}
        id={@currency.id}
        title={@page_title}
        action={@live_action}
        currency={@currency}
        patch={~p"/currencies/#{@currency}"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:currency, Currencies.get_currency!(id))}
  end

  defp page_title(:show), do: gettext("Show Currency")
  defp page_title(:edit), do: gettext("Edit Currency")
end

defmodule PelnanceWeb.TypeLive.Index do
  use PelnanceWeb, :live_view

  alias Pelnance.Types

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <%= gettext("Listing Types") %> <.icon name="hero-banknotes" />
    </.header>

    <.table id="types" rows={@streams.types}>
      <:col :let={{_id, type}} label={gettext("Name")}><%= type.name %></:col>
      <:col :let={{_id, type}} label={gettext("Subtraction")}>
        <%= if type.subtraction do %>
          <div class="h-2.5 w-2.5 rounded-full bg-green-500 me-2"></div>
        <% else %>
          <div class="h-2.5 w-2.5 rounded-full bg-red-500 me-2"></div>
        <% end %>
      </:col>
      <:action :let={{_, type}}>
        <.link navigate={~p"/types/#{type}"}>
          <.icon name="hero-eye" />
        </.link>
      </:action>
    </.table>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :types, Types.list_types())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, gettext("Listing Types"))
    |> assign(:type, nil)
  end
end

defmodule PelnanceWeb.TypeLive.Index do
  use PelnanceWeb, :live_view

  alias Pelnance.{Types, Types.Type}

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <%= gettext("Listing Types") %> <.icon name="hero-banknotes" />
      <:actions>
        <.link patch={~p"/types/new"}>
          <.button><%= gettext("New Type") %></.button>
        </.link>
      </:actions>
    </.header>

    <.table id="types" rows={@streams.types}>
      <:col :let={{_id, type}} label={gettext("Name")}><%= type.name %></:col>
      <:col :let={{_id, type}} label={gettext("Icon")}>
        <%= type.icon %> - <.icon name={type.icon} />
      </:col>
      <:col :let={{_id, type}} label={gettext("Subtraction")}>
        <%= if type.subtraction do %>
          <div class="h-2.5 w-2.5 rounded-full bg-green-500 me-2"></div>
        <% else %>
          <div class="h-2.5 w-2.5 rounded-full bg-red-500 me-2"></div>
        <% end %>
      </:col>
      <:action :let={{id, type}}>
        <.link navigate={~p"/types/#{type}"}>
          <.icon name="hero-eye" />
        </.link>
        <.link patch={~p"/types/#{type}/edit"}>
          <.icon name="hero-pencil-square" />
        </.link>
        <.link
          phx-click={JS.push("delete", value: %{id: type.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          <.icon name="hero-trash" class="text-red-700" />
        </.link>
      </:action>
    </.table>

    <.modal :if={@live_action in [:new, :edit]} id="type-modal" show on_cancel={JS.patch(~p"/types")}>
      <.live_component
        module={PelnanceWeb.TypeLive.FormComponent}
        id={@type.id || :new}
        title={@page_title}
        action={@live_action}
        current_user={@current_user}
        type={@type}
        patch={~p"/types"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :types, Types.list_types(socket.assigns.current_user))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, gettext("Edit Type"))
    |> assign(:type, Types.get_type!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, gettext("New Type"))
    |> assign(:type, %Type{})
    |> assign(:current_user, socket.assigns.current_user)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, gettext("Listing Types"))
    |> assign(:type, nil)
  end

  @impl true
  def handle_info({PelnanceWeb.TypeLive.FormComponent, {:saved, type}}, socket) do
    {:noreply, stream_insert(socket, :types, type)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    type = Types.get_type!(id)
    {:ok, _} = Types.delete_type(type)

    {:noreply, stream_delete(socket, :types, type)}
  end

  def handle_event("generate", _params, socket) do
    Types.generate_types(socket.assigns.current_user)

    {:noreply,
     socket
     |> put_flash(:info, gettext("Types generated successfully"))
     |> redirect(to: ~p"/types")}
  end
end

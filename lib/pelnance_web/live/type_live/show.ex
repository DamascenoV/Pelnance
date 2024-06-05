defmodule PelnanceWeb.TypeLive.Show do
  use PelnanceWeb, :live_view

  alias Pelnance.Types

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <%= gettext("Type") %> Type <%= @type.name %>
      <:actions>
        <.link patch={~p"/types/#{@type}/show/edit"} phx-click={JS.push_focus()}>
          <.button><%= gettext("Edit type") %></.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title={gettext("Name")}><%= @type.name %></:item>
    </.list>

    <.back navigate={~p"/types"}><%= gettext("Back to types") %></.back>

    <.modal :if={@live_action == :edit} id="type-modal" show on_cancel={JS.patch(~p"/types/#{@type}")}>
      <.live_component
        module={PelnanceWeb.TypeLive.FormComponent}
        id={@type.id}
        title={@page_title}
        action={@live_action}
        type={@type}
        patch={~p"/types/#{@type}"}
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
     |> assign(:type, Types.get_type!(id))}
  end

  defp page_title(:show), do: gettext("Show Type")
  defp page_title(:edit), do: gettext("Edit Type")
end

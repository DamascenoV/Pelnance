defmodule PelnanceWeb.TypeLive.Index do
  use PelnanceWeb, :live_view

  alias Pelnance.Types
  alias Pelnance.Types.Type

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :types, Types.list_types())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Type")
    |> assign(:type, Types.get_type!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Type")
    |> assign(:type, %Type{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Types")
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
end
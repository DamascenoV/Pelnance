defmodule PelnanceWeb.TypeLive.Index do
  use PelnanceWeb, :live_view

  alias Pelnance.Types

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

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Types")
    |> assign(:type, nil)
  end

  @impl true
  def handle_info({PelnanceWeb.TypeLive.FormComponent, {:saved, type}}, socket) do
    {:noreply, stream_insert(socket, :types, type)}
  end
end

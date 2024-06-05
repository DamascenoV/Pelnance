defmodule PelnanceWeb.CategoryLive.Show do
  use PelnanceWeb, :live_view

  alias Pelnance.Categories

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <%= gettext("Category") %> <%= @category.name %>
      <:actions>
        <.link patch={~p"/categories/#{@category}/show/edit"} phx-click={JS.push_focus()}>
          <.button>Edit category</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title={gettext("Name")}><%= @category.name %></:item>
    </.list>

    <.back navigate={~p"/categories"}>Back to categories</.back>

    <.modal
      :if={@live_action == :edit}
      id="category-modal"
      show
      on_cancel={JS.patch(~p"/categories/#{@category}")}
    >
      <.live_component
        module={PelnanceWeb.CategoryLive.FormComponent}
        id={@category.id}
        title={@page_title}
        action={@live_action}
        category={@category}
        patch={~p"/categories/#{@category}"}
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
     |> assign(:category, Categories.get_category!(id))}
  end

  defp page_title(:show), do: gettext("Show Category")
  defp page_title(:edit), do: gettext("Edit Category")
end

defmodule PelnanceWeb.CategoryLive.Index do
  use PelnanceWeb, :live_view

  alias Pelnance.Categories
  alias Pelnance.Types
  alias Pelnance.Categories.Category

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <%= gettext("Listing Categories") %> <.icon name="hero-tag" />
      <:actions>
        <.link patch={~p"/categories/new"}>
          <.button><%= gettext("New Category") %></.button>
        </.link>
      </:actions>
    </.header>

    <.table id="categories" rows={@streams.categories}>
      <:col :let={{_id, category}} label={gettext("Name")}><%= category.name %></:col>
      <:col :let={{_id, category}} label={gettext("Type")}>
        <%= category.type.name %>
      </:col>
      <:action :let={{id, category}}>
        <.link navigate={~p"/categories/#{category}"}>
          <.icon name="hero-eye" />
        </.link>
        <.link patch={~p"/categories/#{category}/edit"}>
          <.icon name="hero-pencil-square" />
        </.link>

        <.link
          phx-click={JS.push("delete", value: %{id: category.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          <.icon name="hero-trash" class="text-red-700" />
        </.link>
      </:action>
    </.table>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="category-modal"
      show
      on_cancel={JS.patch(~p"/categories")}
    >
      <.live_component
        module={PelnanceWeb.CategoryLive.FormComponent}
        id={@category.id || :new}
        title={@page_title}
        action={@live_action}
        category={@category}
        current_user={@current_user}
        types={@types}
        patch={~p"/categories"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> stream(:categories, Categories.list_categories(socket.assigns.current_user))
     |> assign(:types, Types.list_types(socket.assigns.current_user))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, gettext("Edit Category"))
    |> assign(:category, Categories.get_category!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, gettext("New Category"))
    |> assign(:category, %Category{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, gettext("Listing Categories"))
    |> assign(:category, nil)
  end

  @impl true
  def handle_info({PelnanceWeb.CategoryLive.FormComponent, {:saved, category}}, socket) do
    {:noreply, stream_insert(socket, :categories, category)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    category = Categories.get_category!(id)
    {:ok, _} = Categories.delete_category(category)

    {:noreply, stream_delete(socket, :categories, category)}
  end
end

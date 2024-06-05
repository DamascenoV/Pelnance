defmodule PelnanceWeb.GoalLive.Index do
  use PelnanceWeb, :live_view

  alias Pelnance.Goals
  alias Pelnance.Goals.Goal

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <%= gettext("Listing Goals") %>
      <:actions>
        <.link patch={~p"/goals/new"}>
          <.button><%= gettext("New Goal") %></.button>
        </.link>
      </:actions>
    </.header>

    <.table id="goals" rows={@streams.goals}>
      <:col :let={{_id, goal}} label={gettext("Name")}><%= goal.name %></:col>
      <:col :let={{_id, goal}} label={gettext("Description")}><%= goal.description %></:col>
      <:col :let={{_id, goal}} label={gettext("Done")}>
        <%= if goal.done do %>
          <div class="h-2.5 w-2.5 rounded-full bg-green-500 me-2"></div>
        <% else %>
          <div class="h-2.5 w-2.5 rounded-full bg-red-500 me-2"></div>
        <% end %>
      </:col>
      <:action :let={{id, goal}}>
        <.link navigate={~p"/goals/#{goal}"}>
          <.icon name="hero-eye" />
        </.link>
        <.link patch={~p"/goals/#{goal}/edit"}>
          <.icon name="hero-pencil-square" />
        </.link>
        <.link
          phx-click={JS.push("delete", value: %{id: goal.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          <.icon name="hero-trash" class="text-red-700" />
        </.link>
      </:action>
    </.table>

    <.modal :if={@live_action in [:new, :edit]} id="goal-modal" show on_cancel={JS.patch(~p"/goals")}>
      <.live_component
        module={PelnanceWeb.GoalLive.FormComponent}
        id={@goal.id || :new}
        title={@page_title}
        action={@live_action}
        goal={@goal}
        current_user={@current_user}
        patch={~p"/goals"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :goals, Goals.list_goals(socket.assigns.current_user))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, gettext("Edit Goal"))
    |> assign(:goal, Goals.get_goal!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, gettext("New Goal"))
    |> assign(:goal, %Goal{})
    |> assign(:current_user, socket.assigns.current_user)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, gettext("Listing Goals"))
    |> assign(:goal, nil)
  end

  @impl true
  def handle_info({PelnanceWeb.GoalLive.FormComponent, {:saved, goal}}, socket) do
    {:noreply, stream_insert(socket, :goals, goal)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    goal = Goals.get_goal!(id)
    {:ok, _} = Goals.delete_goal(goal)

    {:noreply, stream_delete(socket, :goals, goal)}
  end
end

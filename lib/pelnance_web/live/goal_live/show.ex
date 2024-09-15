defmodule PelnanceWeb.GoalLive.Show do
  use PelnanceWeb, :live_view

  alias Pelnance.Goals

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <%= gettext("Goal") %> Goal <%= @goal.id %>
      <:actions>
        <.link patch={~p"/goals/#{@goal}/show/edit"} phx-click={JS.push_focus()}>
          <.button><%= gettext("Edit goal") %></.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title={gettext("Name")}><%= @goal.name %></:item>
      <:item title={gettext("Amount")}><%= @goal.amount %></:item>
      <:item title={gettext("Done")}><%= @goal.done %></:item>
    </.list>

    <.back navigate={~p"/goals"}><%= gettext("Back to goals") %></.back>

    <.modal :if={@live_action == :edit} id="goal-modal" show on_cancel={JS.patch(~p"/goals/#{@goal}")}>
      <.live_component
        module={PelnanceWeb.GoalLive.FormComponent}
        id={@goal.id}
        title={@page_title}
        action={@live_action}
        goal={@goal}
        patch={~p"/goals/#{@goal}"}
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
     |> assign(:goal, Goals.get_goal!(id))}
  end

  defp page_title(:show), do: gettext("Show Goal")
  defp page_title(:edit), do: gettext("Edit Goal")
end

defmodule PelnanceWeb.GoalLive.FormComponent do
  use PelnanceWeb, :live_component

  alias Pelnance.Goals

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
      </.header>

      <.simple_form
        for={@form}
        id="goal-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label={gettext("Name")} />
        <.input field={@form[:description]} type="text" label={gettext("Description")} />
        <.input field={@form[:done]} type="checkbox" label={gettext("Done")} />
        <:actions>
          <.button phx-disable-with="Saving..."><%= gettext("Save Goal") %></.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{goal: goal} = assigns, socket) do
    changeset = Goals.change_goal(goal)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"goal" => goal_params}, socket) do
    changeset =
      socket.assigns.goal
      |> Goals.change_goal(goal_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"goal" => goal_params}, socket) do
    save_goal(socket, socket.assigns.action, goal_params)
  end

  defp save_goal(socket, :edit, goal_params) do
    case Goals.update_goal(socket.assigns.goal, goal_params) do
      {:ok, goal} ->
        notify_parent({:saved, goal})

        {:noreply,
         socket
         |> put_flash(:info, gettext("Goal updated successfully"))
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_goal(socket, :new, goal_params) do
    case Goals.create_goal(socket.assigns.current_user, goal_params) do
      {:ok, goal} ->
        notify_parent({:saved, goal})

        {:noreply,
         socket
         |> put_flash(:info, gettext("Goal created successfully"))
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

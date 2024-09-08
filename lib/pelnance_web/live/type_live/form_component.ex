defmodule PelnanceWeb.TypeLive.FormComponent do
  use PelnanceWeb, :live_component

  alias Pelnance.Types

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
      </.header>

      <div class="flex flex-col gap-4">
        <.button phx-disabled-with="Generating..." class="text-xs" phx-click="generate">
          <%= gettext("Auto Generate Types") %>
        </.button>
      </div>

      <.simple_form
        for={@form}
        id="type-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label={gettext("Name")} />
        <.input field={@form[:subtraction]} type="checkbox" label={gettext("Subtraction")} />
        <:actions>
          <.button phx-disable-with="Saving..."><%= gettext("Save Type") %></.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{type: type} = assigns, socket) do
    changeset = Types.change_type(type)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"type" => type_params}, socket) do
    changeset =
      socket.assigns.type
      |> Types.change_type(type_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"type" => type_params}, socket) do
    save_type(socket, socket.assigns.action, type_params)
  end

  defp save_type(socket, :edit, type_params) do
    case Types.update_type(socket.assigns.type, type_params) do
      {:ok, type} ->
        notify_parent({:saved, type})

        {:noreply,
         socket
         |> put_flash(:info, gettext("Type updated successfully"))
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_type(socket, :new, type_params) do
    case Types.create_type(type_params) do
      {:ok, type} ->
        notify_parent({:saved, type})

        {:noreply,
         socket
         |> put_flash(:info, gettext("Type created successfully"))
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

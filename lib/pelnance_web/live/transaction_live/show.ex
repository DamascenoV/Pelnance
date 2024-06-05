defmodule PelnanceWeb.TransactionLive.Show do
  use PelnanceWeb, :live_view

  alias Pelnance.Transactions

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <%= gettext("Transaction") %> Transaction <%= @transaction.id %>
      <:actions>
        <.link patch={~p"/transactions/#{@transaction}/show/edit"} phx-click={JS.push_focus()}>
          <.button><%= gettext("Edit transaction") %></.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title={gettext("Date")}><%= @transaction.date %></:item>
      <:item title={gettext("Amount")}><%= @transaction.amount %></:item>
      <:item title={gettext("Description")}><%= @transaction.description %></:item>
    </.list>

    <.back navigate={~p"/transactions"}><%= gettext("Back to transactions") %></.back>

    <.modal
      :if={@live_action == :edit}
      id="transaction-modal"
      show
      on_cancel={JS.patch(~p"/transactions/#{@transaction}")}
    >
      <.live_component
        module={PelnanceWeb.TransactionLive.FormComponent}
        id={@transaction.id}
        title={@page_title}
        action={@live_action}
        transaction={@transaction}
        patch={~p"/transactions/#{@transaction}"}
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
     |> assign(:transaction, Transactions.get_transaction!(id))}
  end

  defp page_title(:show), do: gettext("Show Transaction")
  defp page_title(:edit), do: gettext("Edit Transaction")
end

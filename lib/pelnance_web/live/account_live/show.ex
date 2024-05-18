defmodule PelnanceWeb.AccountLive.Show do
  use PelnanceWeb, :live_view

  alias Pelnance.Accounts
  alias Pelnance.Transactions
  alias Pelnance.Currencies

  @impl true
  def mount(params, _session, socket) do
    IO.inspect(params)

    {:ok,
     socket
     |> stream(:transactions, Transactions.list_transactions_from_account(params["id"]),
       at: 0,
       limit: 2
     )
     |> assign(:currencies, Currencies.list_currencies(socket.assigns.current_user))}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:account, Accounts.get_account!(id))}
  end

  defp page_title(:show), do: gettext("Show Account")
  defp page_title(:edit), do: gettext("Edit Account")
end

defmodule PelnanceWeb.SettingLive.Index do
  use PelnanceWeb, :live_view

  alias Pelnance.{Types, Currencies, Categories}

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Settings</h1>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    {:ok,
     socket
     |> assign(:types, Types.list_types(user))
     |> assign(:currencies, Currencies.list_currencies(user))
     |> assign(:categories, Categories.list_categories(user))}
  end

end

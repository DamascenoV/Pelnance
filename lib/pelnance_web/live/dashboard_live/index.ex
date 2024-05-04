defmodule PelnanceWeb.DashboardLive.Index do
  use PelnanceWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Dashboard</h1>
    """
  end
end

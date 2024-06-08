defmodule PelnanceWeb.DashboardLive.FormType do
  use PelnanceWeb, :live_component

  alias Pelnance.Types.Type

  attr :current_user, :any, required: true

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.live_component
        module={PelnanceWeb.TypeLive.FormComponent}
        id={:new}
        title="Create a new type"
        action={:new}
        current_user={@current_user}
        type={%Type{}}
        patch={~p"/dashboard"}
      />
    </div>
    """
  end
end

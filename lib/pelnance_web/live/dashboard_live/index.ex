defmodule PelnanceWeb.DashboardLive.Index do
  use PelnanceWeb, :live_view

  alias Pelnance.Users

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h1>Dashboard</h1>
      <%= if @step_number < 4 do %>
        <p class="text-md text-red-500">Please complete your setup in the steps below.</p>
        <.progress_bar step_number={@step_number} />
      <% end %>
      <div class="flex flex-col gap-4 mt-4">
        <%= if @user.currencies == [] do %>
          <.button phx-click="create_currency">Create new currency</.button>
          <.modal
            :if={@live_action == :new_currency}
            id="currency-modal"
            show
            on_cancel={JS.patch(~p"/dashboard")}
          >
            <.live_component
              module={PelnanceWeb.CurrencyLive.FormComponent}
              id={:new}
              title="Create new currency"
              action={:new}
              currency={%Pelnance.Currencies.Currency{}}
              current_user={@user}
              patch={~p"/dashboard"}
            />
          </.modal>
        <% end %>
        <%= if @user.types == [] do %>
          <.button phx-click="create_type">Create new type</.button>
          <.modal
            :if={@live_action == :new_type}
            id="type-modal"
            show
            on_cancel={JS.patch(~p"/dashboard")}
          >
            <.live_component
              module={PelnanceWeb.TypeLive.FormComponent}
              id={:new}
              title="Create new type"
              action={:new}
              type={%Pelnance.Types.Type{}}
              current_user={@user}
              patch={~p"/dashboard"}
            />
          </.modal>
        <% end %>
        <%= if @user.categories == [] do %>
          <.button phx-click="create_category">Create new category</.button>
          <.modal
            :if={@live_action == :new_category}
            id="category-modal"
            show
            on_cancel={JS.patch(~p"/dashboard")}
          >
            <.live_component
              module={PelnanceWeb.CategoryLive.FormComponent}
              id={:new}
              title="Create new category"
              action={:new}
              category={%Pelnance.Categories.Category{}}
              current_user={@user}
              types={@user.types}
              patch={~p"/dashboard"}
            />
          </.modal>
        <% end %>
        <%= if @user.accounts == [] do %>
          <.button phx-click="create_account">Create new account</.button>
          <.modal
            :if={@live_action == :new_account}
            id="account-modal"
            show
            on_cancel={JS.patch(~p"/dashboard")}
          >
            <.live_component
              module={PelnanceWeb.AccountLive.FormComponent}
              id={:new}
              title="Create new account"
              action={:new}
              account={%Pelnance.Accounts.Account{}}
              current_user={@user}
              currencies={@user.currencies}
              patch={~p"/dashboard"}
            />
          </.modal>
        <% end %>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    user = Users.prepare_user(socket.assigns.current_user)

    step_number =
      Enum.count([user.currencies, user.types, user.categories, user.accounts], fn x ->
        !Enum.empty?(x)
      end)

    {
      :ok,
      socket
      |> assign(:user, user)
      |> assign(:step_number, step_number)
    }
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("create_currency", _params, socket) do
    {:noreply, push_patch(socket, to: ~p"/dashboard/new_currency")}
  end

  @impl true
  def handle_event("create_type", _params, socket) do
    {:noreply, push_patch(socket, to: ~p"/dashboard/new_type")}
  end

  @impl true
  def handle_event("create_category", _params, socket) do
    {:noreply, push_patch(socket, to: ~p"/dashboard/new_category")}
  end

  @impl true
  def handle_event("create_account", _params, socket) do
    {:noreply, push_patch(socket, to: ~p"/dashboard/new_account")}
  end

  def handle_event("generate", _params, socket) do
    Pelnance.Types.generate_types(socket.assigns.current_user)

    socket =
      socket
      |> assign(socket, user: Users.prepare_user(socket.assigns.current_user))
      |> put_flash(:info, gettext("Types generated successfully"))

    {:noreply, socket}
  end

  @impl true
  def handle_info({_, {:saved, _}}, socket) do
    socket =
      socket
      |> assign(step_number: socket.assigns.step_number + 1)
      |> assign(user: Users.prepare_user(socket.assigns.current_user))

    {:noreply, socket}
  end
end

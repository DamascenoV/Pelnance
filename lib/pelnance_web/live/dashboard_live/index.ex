defmodule PelnanceWeb.DashboardLive.Index do
  use PelnanceWeb, :live_view

  alias Pelnance.Users

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h1>Dashboard</h1>
      <%= if @step_number < 4 do %>
        <p class="text-md text-red-500">
          <%= gettext("Please complete your setup in the steps below") %>.
        </p>
        <.progress_bar step_number={@step_number} />
      <% end %>
      <div class="flex flex-col gap-4 mt-4">
        <%= if @user.currencies == [] do %>
          <.button phx-click="create_currency"><%= gettext("Create new currency") %></.button>
          <.modal
            :if={@live_action == :new_currency}
            id="currency-modal"
            show
            on_cancel={JS.patch(~p"/dashboard")}
          >
            <.live_component
              module={PelnanceWeb.CurrencyLive.FormComponent}
              id={:new}
              title={gettext("Create new currency")}
              action={:new}
              currency={%Pelnance.Currencies.Currency{}}
              current_user={@user}
              patch={~p"/dashboard"}
            />
          </.modal>
        <% end %>
        <%= if @user.types == [] do %>
          <.button phx-click="create_type"><%= gettext("Create new type") %></.button>
          <.modal
            :if={@live_action == :new_type}
            id="type-modal"
            show
            on_cancel={JS.patch(~p"/dashboard")}
          >
            <.live_component
              module={PelnanceWeb.TypeLive.FormComponent}
              id={:new}
              title={gettext("Create new type")}
              action={:new}
              type={%Pelnance.Types.Type{}}
              current_user={@user}
              patch={~p"/dashboard"}
            />
          </.modal>
        <% end %>
        <%= if @user.categories == [] do %>
          <.button phx-click="create_category"><%= gettext("Create new category") %></.button>
          <.modal
            :if={@live_action == :new_category}
            id="category-modal"
            show
            on_cancel={JS.patch(~p"/dashboard")}
          >
            <.live_component
              module={PelnanceWeb.CategoryLive.FormComponent}
              id={:new}
              title={gettext("Create new category")}
              action={:new}
              category={%Pelnance.Categories.Category{}}
              current_user={@user}
              types={@user.types}
              patch={~p"/dashboard"}
            />
          </.modal>
        <% end %>
        <%= if @user.accounts == [] do %>
          <.button phx-click="create_account"><%= gettext("Create new account") %></.button>
          <.modal
            :if={@live_action == :new_account}
            id="account-modal"
            show
            on_cancel={JS.patch(~p"/dashboard")}
          >
            <.live_component
              module={PelnanceWeb.AccountLive.FormComponent}
              id={:new}
              title={gettext("Create new account")}
              action={:new}
              account={%Pelnance.Accounts.Account{}}
              current_user={@user}
              currencies={@user.currencies}
              patch={~p"/dashboard"}
            />
          </.modal>
        <% end %>
      </div>
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        <div class="rounded-lg border text-card-foreground bg-background shadow-lg" data-v0-t="card">
          <div class="flex flex-col space-y-1.5 p-6">
            <h3 class="whitespace-nowrap text-2xl font-semibold leading-none tracking-tight">
              Accounts
            </h3>
            <p class="text-sm text-muted-foreground">View and manage your financial accounts.</p>
          </div>
          <div class="p-6 grid gap-4">
            <div class="flex items-center justify-between">
              <div>
                <div class="text-2xl font-bold">$12,345.67</div>
                <div class="text-muted-foreground text-sm">Total Balance</div>
              </div>
              <button class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input bg-background hover:bg-accent hover:text-accent-foreground h-9 rounded-md px-3">
                View Accounts
              </button>
            </div>
            <div class="grid grid-cols-2 gap-4">
              <div>
                <div class="text-xl font-bold">3</div>
                <div class="text-muted-foreground text-sm">Checking</div>
              </div>
              <div>
                <div class="text-xl font-bold">2</div>
                <div class="text-muted-foreground text-sm">Savings</div>
              </div>
              <div>
                <div class="text-xl font-bold">1</div>
                <div class="text-muted-foreground text-sm">Credit Card</div>
              </div>
              <div>
                <div class="text-xl font-bold">1</div>
                <div class="text-muted-foreground text-sm">Investment</div>
              </div>
            </div>
          </div>
        </div>
        <div class="rounded-lg border text-card-foreground bg-background shadow-lg" data-v0-t="card">
          <div class="flex flex-col space-y-1.5 p-6">
            <h3 class="whitespace-nowrap text-2xl font-semibold leading-none tracking-tight">
              Transactions
            </h3>
            <p class="text-sm text-muted-foreground">View and manage your financial transactions.</p>
          </div>
          <div class="p-6 grid gap-4">
            <div class="flex items-center justify-between">
              <div>
                <div class="text-2xl font-bold">$2,345.67</div>
                <div class="text-muted-foreground text-sm">Total Transactions</div>
              </div>
              <button class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input bg-background hover:bg-accent hover:text-accent-foreground h-9 rounded-md px-3">
                View Transactions
              </button>
            </div>
            <div class="grid grid-cols-2 gap-4">
              <div>
                <div class="text-xl font-bold">45</div>
                <div class="text-muted-foreground text-sm">Expenses</div>
              </div>
              <div>
                <div class="text-xl font-bold">12</div>
                <div class="text-muted-foreground text-sm">Income</div>
              </div>
              <div>
                <div class="text-xl font-bold">3</div>
                <div class="text-muted-foreground text-sm">Transfers</div>
              </div>
              <div>
                <div class="text-xl font-bold">2</div>
                <div class="text-muted-foreground text-sm">Investments</div>
              </div>
            </div>
          </div>
        </div>
        <div class="rounded-lg border text-card-foreground bg-background shadow-lg" data-v0-t="card">
          <div class="flex flex-col space-y-1.5 p-6">
            <h3 class="whitespace-nowrap text-2xl font-semibold leading-none tracking-tight">
              Goals
            </h3>
            <p class="text-sm text-muted-foreground">View and manage your financial goals.</p>
          </div>
          <div class="p-6 grid gap-4">
            <div class="flex items-center justify-between">
              <div>
                <div class="text-2xl font-bold">$5,000.00</div>
                <div class="text-muted-foreground text-sm">Total Goal Amount</div>
              </div>
              <button class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input bg-background hover:bg-accent hover:text-accent-foreground h-9 rounded-md px-3">
                View Goals
              </button>
            </div>
            <div class="grid grid-cols-2 gap-4">
              <div>
                <div class="text-xl font-bold">3</div>
                <div class="text-muted-foreground text-sm">Savings</div>
              </div>
              <div>
                <div class="text-xl font-bold">2</div>
                <div class="text-muted-foreground text-sm">Investments</div>
              </div>
              <div>
                <div class="text-xl font-bold">1</div>
                <div class="text-muted-foreground text-sm">Vacation</div>
              </div>
              <div>
                <div class="text-xl font-bold">1</div>
                <div class="text-muted-foreground text-sm">Debt Payoff</div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="mt-8">
        <h2 class="text-2xl font-bold mb-4">Recent Transactions</h2>
        <div class="rounded-lg border text-card-foreground bg-background shadow-lg" data-v0-t="card">
          <div class="p-6">
            <div class="relative w-full overflow-auto">
              <table class="w-full caption-bottom text-sm">
                <thead class="[&amp;_tr]:border-b">
                  <tr class="border-b transition-colors hover:bg-muted/50 data-[state=selected]:bg-muted">
                    <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground [&amp;:has([role=checkbox])]:pr-0">
                      Date
                    </th>
                    <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground [&amp;:has([role=checkbox])]:pr-0">
                      Description
                    </th>
                    <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground [&amp;:has([role=checkbox])]:pr-0">
                      Amount
                    </th>
                    <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground [&amp;:has([role=checkbox])]:pr-0">
                      Category
                    </th>
                    <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground [&amp;:has([role=checkbox])]:pr-0">
                      Account
                    </th>
                  </tr>
                </thead>
                <tbody class="[&amp;_tr:last-child]:border-0">
                  <tr class="border-b transition-colors hover:bg-muted/50 data-[state=selected]:bg-muted">
                    <td class="p-4 align-middle [&amp;:has([role=checkbox])]:pr-0">2023-06-25</td>
                    <td class="p-4 align-middle [&amp;:has([role=checkbox])]:pr-0">Groceries</td>
                    <td class="p-4 align-middle [&amp;:has([role=checkbox])]:pr-0">-$125.43</td>
                    <td class="p-4 align-middle [&amp;:has([role=checkbox])]:pr-0">Expenses</td>
                    <td class="p-4 align-middle [&amp;:has([role=checkbox])]:pr-0">Checking 1234</td>
                  </tr>
                  <tr class="border-b transition-colors hover:bg-muted/50 data-[state=selected]:bg-muted">
                    <td class="p-4 align-middle [&amp;:has([role=checkbox])]:pr-0">2023-06-23</td>
                    <td class="p-4 align-middle [&amp;:has([role=checkbox])]:pr-0">Paycheck</td>
                    <td class="p-4 align-middle [&amp;:has([role=checkbox])]:pr-0">$2,500.00</td>
                    <td class="p-4 align-middle [&amp;:has([role=checkbox])]:pr-0">Income</td>
                    <td class="p-4 align-middle [&amp;:has([role=checkbox])]:pr-0">Checking 1234</td>
                  </tr>
                  <tr class="border-b transition-colors hover:bg-muted/50 data-[state=selected]:bg-muted">
                    <td class="p-4 align-middle [&amp;:has([role=checkbox])]:pr-0">2023-06-21</td>
                    <td class="p-4 align-middle [&amp;:has([role=checkbox])]:pr-0">Rent Payment</td>
                    <td class="p-4 align-middle [&amp;:has([role=checkbox])]:pr-0">-$1,200.00</td>
                    <td class="p-4 align-middle [&amp;:has([role=checkbox])]:pr-0">Expenses</td>
                    <td class="p-4 align-middle [&amp;:has([role=checkbox])]:pr-0">Checking 1234</td>
                  </tr>
                  <tr class="border-b transition-colors hover:bg-muted/50 data-[state=selected]:bg-muted">
                    <td class="p-4 align-middle [&amp;:has([role=checkbox])]:pr-0">2023-06-18</td>
                    <td class="p-4 align-middle [&amp;:has([role=checkbox])]:pr-0">
                      Amazon Purchase
                    </td>
                    <td class="p-4 align-middle [&amp;:has([role=checkbox])]:pr-0">-$49.99</td>
                    <td class="p-4 align-middle [&amp;:has([role=checkbox])]:pr-0">Expenses</td>
                    <td class="p-4 align-middle [&amp;:has([role=checkbox])]:pr-0">
                      Credit Card 5678
                    </td>
                  </tr>
                  <tr class="border-b transition-colors hover:bg-muted/50 data-[state=selected]:bg-muted">
                    <td class="p-4 align-middle [&amp;:has([role=checkbox])]:pr-0">2023-06-15</td>
                    <td class="p-4 align-middle [&amp;:has([role=checkbox])]:pr-0">
                      Savings Transfer
                    </td>
                    <td class="p-4 align-middle [&amp;:has([role=checkbox])]:pr-0">-$500.00</td>
                    <td class="p-4 align-middle [&amp;:has([role=checkbox])]:pr-0">Transfer</td>
                    <td class="p-4 align-middle [&amp;:has([role=checkbox])]:pr-0">Checking 1234</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
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

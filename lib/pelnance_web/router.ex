defmodule PelnanceWeb.Router do
  use PelnanceWeb, :router

  import PelnanceWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PelnanceWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PelnanceWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", PelnanceWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:pelnance, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PelnanceWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", PelnanceWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{PelnanceWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", PelnanceWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{PelnanceWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email

      # DASHBOARD ROUTES
      live "/dashboard", DashboardLive.Index, :index

      # CURRENCIES ROUTES
      live "/currencies", CurrencyLive.Index, :index
      live "/currencies/new", CurrencyLive.Index, :new
      live "/currencies/:id/edit", CurrencyLive.Index, :edit
      live "/currencies/:id", CurrencyLive.Show, :show
      live "/currencies/:id/show/edit", CurrencyLive.Show, :edit

      # TYPES ROUTES
      live "/types", TypeLive.Index, :index
      live "/types/new", TypeLive.Index, :new
      live "/types/:id/edit", TypeLive.Index, :edit
      live "/types/:id", TypeLive.Show, :show
      live "/types/:id/show/edit", TypeLive.Show, :edit

      # ACCOUNTS ROUTES
      live "/accounts", AccountLive.Index, :index
      live "/accounts/new", AccountLive.Index, :new
      live "/accounts/:id/edit", AccountLive.Index, :edit
      live "/accounts/:id", AccountLive.Show, :show
      live "/accounts/:id/show/edit", AccountLive.Show, :edit

      # CATEGORIES ROUTES
      live "/categories", CategoryLive.Index, :index
      live "/categories/new", CategoryLive.Index, :new
      live "/categories/:id/edit", CategoryLive.Index, :edit
      live "/categories/:id", CategoryLive.Show, :show
      live "/categories/:id/show/edit", CategoryLive.Show, :edit

      # TRANSACTIONS ROUTES
      live "/transactions", TransactionLive.Index, :index
      live "/transactions/new", TransactionLive.Index, :new
      live "/transactions/:id/edit", TransactionLive.Index, :edit
      live "/transactions/:id", TransactionLive.Show, :show
      live "/transactions/:id/show/edit", TransactionLive.Show, :edit

      # GOALS ROUTES
      live "/goals", GoalLive.Index, :index
      live "/goals/new", GoalLive.Index, :new
      live "/goals/:id/edit", GoalLive.Index, :edit
      live "/goals/:id", GoalLive.Show, :show
      live "/goals/:id/show/edit", GoalLive.Show, :edit
    end
  end

  scope "/", PelnanceWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{PelnanceWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end

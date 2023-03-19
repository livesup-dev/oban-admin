defmodule ObanAdminWeb.Router do
  use ObanAdminWeb, :router

  import ObanAdminWeb.Auth.UserAuth

  pipeline :unauthenticated_layout do
    plug(:put_root_layout, {ObanAdminWeb.LayoutView, :unauthenticated})
  end

  pipeline :logged_in_layout do
    plug(:put_layout, {ObanAdminWeb.LayoutView, :app})
  end

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {ObanAdminWeb.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_user)
  end

  pipeline :auth do
    plug(Ueberauth)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", ObanAdminWeb do
    pipe_through([:browser, :logged_in_layout, :require_authenticated_user])

    live("/", Live.HomeLive, :index)
    live("/jobs", Live.JobLive, :index)
  end

  scope "/oauth", ObanAdminWeb do
    pipe_through([:browser, :auth])
    get("/:provider", OAuthController, :request)
    get("/:provider/callback", OAuthController, :callback)
  end

  ## Authentication routes

  scope "/", ObanAdminWeb do
    pipe_through([:browser, :unauthenticated_layout, :redirect_if_user_is_authenticated])

    get("/users/log-in", Auth.UserSessionController, :new)
    post("/users/log-in", Auth.UserSessionController, :create)
  end

  scope "/", ObanAdminWeb do
    pipe_through([:browser])

    delete("/users/log-out", Auth.UserSessionController, :delete)
  end

  # Other scopes may use custom stacks.
  # scope "/api", ObanAdminWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: ObanAdminWeb.Telemetry)
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through(:browser)

      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end

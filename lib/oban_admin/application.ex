defmodule ObanAdmin.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    OpentelemetryPhoenix.setup()
    OpentelemetryLiveView.setup()
    OpentelemetryEcto.setup([:oban_admin, :repo])

    children = [
      # Start the Ecto repository
      ObanAdmin.Repo,
      # Start the Telemetry supervisor
      ObanAdminWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ObanAdmin.PubSub},
      # Start the Endpoint (http/https)
      ObanAdminWeb.Endpoint
      # Start a worker by calling: ObanAdmin.Worker.start_link(arg)
      # {ObanAdmin.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ObanAdmin.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ObanAdminWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

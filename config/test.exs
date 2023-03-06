import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :oban_admin, ObanAdmin.Repo,
  username: System.get_env("PGUSER") || "postgres",
  password: System.get_env("PGPASSWORD") || "postgres",
  hostname: System.get_env("PGHOST") || "localhost",
  database: "oban_admin_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :oban_admin, ObanAdminWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "h9T+tJjRwWJLvJLgcOfRMYUyTnWN0ypS91sZEjsqyem5tDntVsonMenbYbraDIZw",
  server: false

# In test we don't send emails.
config :oban_admin, ObanAdmin.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :opentelemetry,
  traces_exporter: :none

config :opentelemetry, :processors, [
  {:otel_simple_processor, %{}}
]

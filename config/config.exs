# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :oban_admin,
  ecto_repos: [ObanAdmin.Repo]

# Configures the endpoint
config :oban_admin, ObanAdminWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: ObanAdminWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ObanAdmin.PubSub,
  live_view: [signing_salt: "YYtg19Ftse9k65yrYjPHV8aujQ9NsITOL890lQ=="]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :oban_admin, ObanAdmin.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.2.1",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ueberauth, Ueberauth,
  base_path: "/oauth",
  providers: [
    okta: {
      Ueberauth.Strategy.Okta,
      [
        oauth2_params: [scope: "openid email"]
      ]
    }
  ]

config :rollbax,
  enable_crash_reports: false,
  enabled: false

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

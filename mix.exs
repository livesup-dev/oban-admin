defmodule ObanAdmin.MixProject do
  use Mix.Project

  def project do
    [
      app: :oban_admin,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      aliases: aliases(),
      deps: deps(),
      releases: [
        oban_admin: [
          applications: [
            oban_admin: :permanent,
            opentelemetry_exporter: :permanent,
            opentelemetry: :temporary
          ]
        ]
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {ObanAdmin.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # Assets bundling
      {:tailwind, "~> 0.1", runtime: Mix.env() == :dev},
      {:esbuild, "~> 0.6", runtime: Mix.env() == :dev},

      # Phoenix
      {:phoenix, "~> 1.6.12"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.18.3"},
      {:phoenix_live_dashboard, "~> 0.6"},
      {:phx_component_helpers, "~> 1.2.0"},

      # HTTPClient
      {:finch, "~> 0.8"},

      # Database
      {:ecto_sql, "~> 3.6"},
      {:postgrex, ">= 0.0.0"},

      # HTML Parser
      {:floki, ">= 0.30.0", only: :test},

      # Opentelemetry
      {:opentelemetry_exporter, "~> 1.4.0"},
      {:opentelemetry, "~> 1.2.0"},
      {:opentelemetry_api, "~> 1.2.0"},
      {:opentelemetry_ecto, "~> 1.1.0"},
      {:opentelemetry_phoenix, "~> 1.1.0"},
      {:opentelemetry_liveview, "~> 1.0.0-rc.4"},
      {:logger_json, "~> 5.1"},

      # Monitoring
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:rollbax, ">= 0.0.0"},

      # Translations
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},
      {:swoosh, "~> 1.9"},

      # OAuth
      {:oauth2, "~> 2.0"},
      {:ueberauth, "~> 0.7"},
      {:ueberauth_okta, "~> 0.3"},

      # Additional packages
      {:bcrypt_elixir, "~> 3.0"},

      # Security check
      {:sobelow, "~> 0.11", only: [:dev, :test], runtime: true},
      {:mix_audit, "~> 2.1", only: [:dev, :test], runtime: false},

      # Test coverage
      {:excoveralls, "~> 0.15", only: :test},

      # Testing tools
      {:bypass, "~> 2.1", only: :test},
      {:mock, "~> 0.3.0", only: :test},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false}
    ] ++
      private_deps()
  end

  def private_deps() do
    palette_dep(File.exists?("../palette"))
  end

  def palette_dep(true = _local) do
    [{:palette, path: "../palette"}]
  end

  def palette_dep(false) do
    [
      {:palette, git: "https://github.com/livesup-dev/palette", tag: "0.1.31"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "phx.routes": "phx.routes ObanAdminWeb.Router",
      setup: ["deps.get", "cmd npm install --prefix assets", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.deploy": [
        "tailwind default --minify",
        "esbuild default --minify",
        "phx.digest"
      ]
    ]
  end
end

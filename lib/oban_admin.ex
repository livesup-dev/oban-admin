defmodule ObanAdmin do
  def config_runtime do
    import Config

    config :oban_admin, ObanAdminWeb.Endpoint,
      secret_key_base:
        ObanAdmin.Config.secret!("OBAN_ADMIN_SECRET_KEY_BASE") ||
          Base.encode64(:crypto.strong_rand_bytes(48))

    if port = ObanAdmin.Config.port!("OBAN_ADMIN_HTTP_PORT") do
      config :oban_admin, ObanAdminWeb.Endpoint, http: [port: port]
    end

    if hostname = ObanAdmin.Config.hostname!("OBAN_ADMIN_HOSTNAME") do
      config :oban_admin, ObanAdminWeb.Endpoint, url: [host: hostname]
    end

    if ip = ObanAdmin.Config.ip!("OBAN_ADMIN_IP") do
      config :oban_admin, ObanAdminWeb.Endpoint, http: [ip: ip]
    end

    if ssl = ObanAdmin.Config.db_ssl!("OBAN_ADMIN_DATABASE_SSL") do
      config :oban_admin, ObanAdmin.Repo, ssl: ssl
    end

    if okta_client_id = ObanAdmin.Config.okta_client_id() do
      config :ueberauth, Ueberauth.Strategy.Okta.OAuth, client_id: okta_client_id
    end

    if okta_client_secret = ObanAdmin.Config.okta_client_secret() do
      config :ueberauth, Ueberauth.Strategy.Okta.OAuth, client_secret: okta_client_secret
    end

    if okta_site = ObanAdmin.Config.okta_site() do
      config :ueberauth, Ueberauth.Strategy.Okta.OAuth, site: okta_site
    end

    config :ueberauth, Ueberauth.Strategy.Okta.OAuth,
      authorize_url: ObanAdmin.Config.oidc_authorize_url(),
      token_url: ObanAdmin.Config.oidc_token_url(),
      userinfo_url: ObanAdmin.Config.oidc_userinfo_url(),
      site: ObanAdmin.Config.okta_site(),
      client_id: ObanAdmin.Config.okta_client_id(),
      client_secret: ObanAdmin.Config.okta_client_secret()

    if otel_endpoint = ObanAdmin.Config.otel_endpoint() do
      config :opentelemetry,
        span_processor: :batch,
        traces_exporter: :otlp

      config :opentelemetry_exporter,
        otlp_protocol: :http_protobuf,
        otlp_endpoint: otel_endpoint
    end
  end
end

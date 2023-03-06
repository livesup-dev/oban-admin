defmodule ObanAdmin.Config do
  def secret!(env) do
    if secret_key_base = System.get_env(env) do
      if byte_size(secret_key_base) < 64 do
        abort!(
          "cannot start ObanAdmin because #{env} must be at least 64 characters. " <>
            "Invoke `openssl rand -base64 48` to generate an appropriately long secret."
        )
      end

      secret_key_base
    end
  end

  def db_ssl!(env) do
    if ssl = System.get_env(env) do
      if ssl == "true" do
        true
      else
        false
      end
    else
      false
    end
  end

  @doc """
  Parses and validates the port from env.
  """
  def port!(env) do
    if port = System.get_env(env) do
      case Integer.parse(port) do
        {port, ""} -> port
        :error -> abort!("expected #{env} to be an integer, got: #{inspect(port)}")
      end
    end
  end

  def hostname!(env) do
    if hostname = System.get_env(env) do
      hostname
    end
  end

  @doc """
  Parses and validates the ip from env.
  """
  def ip!(env) do
    if ip = System.get_env(env) do
      ip!(env, ip)
    end
  end

  @doc """
  Parses and validates the ip within context.
  """
  def ip!(context, ip) do
    case ip |> String.to_charlist() |> :inet.parse_address() do
      {:ok, ip} ->
        ip

      {:error, :einval} ->
        abort!("expected #{context} to be a valid ipv4 or ipv6 address, got: #{ip}")
    end
  end

  @doc """
  Parses the cookie from env.
  """
  def cookie!(env) do
    if cookie = System.get_env(env) do
      String.to_atom(cookie)
    end
  end

  @doc """
  Aborts booting due to a configuration error.
  """
  @spec abort!(String.t()) :: no_return()
  def abort!(message) do
    IO.puts("\nERROR!!! [ObanAdmin] " <> message)
    System.halt(1)
  end

  def okta_client_secret() do
    System.get_env("OKTA_CLIENT_SECRET")
  end

  def okta_site() do
    System.get_env("OKTA_SITE")
  end

  def okta_client_id() do
    System.get_env("OKTA_CLIENT_ID")
  end

  def hydra_url() do
    System.get_env("HYDRA_URL") || default_value(:hydra_url)
  end

  def otel_endpoint() do
    System.get_env("OTEL_EXPORTER_ENDPOINT")
  end

  def oidc_authorize_url() do
    "#{oidc_issuer()}/v1/authorize"
  end

  def oidc_token_url() do
    "#{oidc_issuer()}/v1/token"
  end

  def oidc_userinfo_url() do
    "#{oidc_issuer()}/v1/userinfo"
  end

  def oidc_issuer() do
    System.get_env("OIDC_ISSUER")
  end

  defp default_value(key), do: Application.get_env(:oban_admin, key)
end

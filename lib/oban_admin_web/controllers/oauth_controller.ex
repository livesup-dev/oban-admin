defmodule ObanAdminWeb.OAuthController do
  use ObanAdminWeb, :controller
  plug(Ueberauth)

  alias ObanAdmin.Core.Accounts
  alias ObanAdminWeb.Auth.UserAuth

  @rand_pass_length 32

  def callback(%{assigns: %{ueberauth_auth: %{info: user_info}}} = conn, %{"provider" => provider}) do
    user_params = %{
      email: user_info.email,
      password: random_password(),
      first_name: user_info.first_name,
      last_name: user_info.last_name,
      avatar_url: user_info.image,
      provider: provider
    }

    case Accounts.fetch_or_create_user(user_params) do
      {:ok, user} ->
        UserAuth.log_in_user(conn, user)

      _ ->
        conn
        |> put_flash(:error, "Authentication failed")
        |> redirect(to: "/")
    end
  end

  def callback(conn, _params) do
    conn
    |> put_flash(:error, "Authentication failed")
    |> redirect(to: "/")
  end

  defp random_password do
    :crypto.strong_rand_bytes(@rand_pass_length) |> Base.encode64()
  end
end

defmodule ObanAdminWeb.SignInController do
  use ObanAdminWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", %{title: "Sign In"})
  end
end

defmodule ObanAdminWeb.FallbackController do
  use Phoenix.Controller

  def call(conn, {:error, :unauthorized}) do
    conn
    |> show_404()
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> show_404()
  end

  def show_404(conn) do
    conn
    |> put_status(:not_found)
    |> put_view(ObanAdminWeb.ErrorView)
    |> put_root_layout({ObanAdminWeb.LayoutView, :root})
    |> render(:"404")
  end
end

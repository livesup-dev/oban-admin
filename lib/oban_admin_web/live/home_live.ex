defmodule ObanAdminWeb.Live.HomeLive do
  use ObanAdminWeb, :live_view
  on_mount(ObanAdmin.UserLiveAuth)

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:section, :home)}
  end
end

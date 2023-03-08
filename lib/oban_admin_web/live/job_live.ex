defmodule ObanAdminWeb.Live.JobLive do
  use ObanAdminWeb, :live_view
  on_mount(ObanAdmin.UserLiveAuth)

  alias Palette.Components.Breadcrumb.Step

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:section, :home)
     |> assign_breadcrumb_steps()
     |> assign_defaults()
     |> assign_jobs(self())}
  end

  defp assign_breadcrumb_steps(socket) do
    steps = [
      %Step{label: "Oban"},
      %Step{label: "Jobs"}
    ]

    socket
    |> assign(:steps, steps)
  end

  def assign_defaults(socket) do
    socket
    |> assign(:jobs, [])
    |> assign(:last_updated_at, nil)
  end

  def assign_jobs(socket, pid) do
    fetch_jobs(pid)
    socket
  end

  def fetch_jobs(pid) do
    Task.start(fn ->
      jobs = ObanAdmin.Queries.JobQuery.all()
      send(pid, {:jobs_fetched, %{jobs: jobs, last_updated_at: DateTime.utc_now()}})
      :timer.sleep(2000)
      fetch_jobs(pid)
    end)
  end

  def handle_info({:jobs_fetched, %{jobs: jobs, last_updated_at: last_updated_at}}, socket) do
    last_updated_at |> dbg

    {:noreply,
     socket
     |> assign(:jobs, jobs)
     |> assign(:last_updated_at, last_updated_at)}
  end

  def state_color("completed"), do: :success
  def state_color("executing"), do: :primary
  def state_color("scheduled"), do: :info
  def state_color("discarded"), do: :error
  def state_color("retryable"), do: :warning
  def state_color(_), do: :default

  def format_date(nil), do: "Updated at: N/A"

  def format_date(date) do
    updated_at = date |> Timex.format!("{h24}:{m}:{s}")
    "Updated: #{updated_at}"
  end
end

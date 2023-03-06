defmodule ObanAdmin.Repo do
  use Ecto.Repo,
    otp_app: :oban_admin,
    adapter: Ecto.Adapters.Postgres
end

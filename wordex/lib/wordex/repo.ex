defmodule Wordex.Repo do
  use Ecto.Repo,
    otp_app: :wordex,
    adapter: Ecto.Adapters.Postgres
end

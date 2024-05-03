defmodule Pelnance.Repo do
  use Ecto.Repo,
    otp_app: :pelnance,
    adapter: Ecto.Adapters.SQLite3
end

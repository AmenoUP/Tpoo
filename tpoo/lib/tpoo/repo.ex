defmodule Tpoo.Repo do
  use Ecto.Repo,
    otp_app: :tpoo,
    adapter: Ecto.Adapters.Postgres
end

defmodule Kotkowo.Repo do
  use Ecto.Repo,
    otp_app: :kotkowo,
    adapter: Ecto.Adapters.Postgres
end

defmodule WordleClone.Repo do
  use Ecto.Repo,
    otp_app: :wordle_clone,
    adapter: Ecto.Adapters.Postgres
end

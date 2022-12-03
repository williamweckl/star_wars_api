defmodule StarWars.Repo do
  use Ecto.Repo,
    otp_app: :star_wars,
    adapter: Ecto.Adapters.Postgres
end

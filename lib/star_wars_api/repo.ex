defmodule StarWarsAPI.Repo do
  use Ecto.Repo,
    otp_app: :star_wars_api,
    adapter: Ecto.Adapters.Postgres
end

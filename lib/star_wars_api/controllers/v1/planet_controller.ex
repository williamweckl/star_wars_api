defmodule StarWarsAPI.V1.PlanetController do
  use StarWarsAPI, :controller

  alias StarWarsAPI.V1.PlanetSerializer

  alias CleanArchitecture.Pagination

  def index(conn, %{} = params) do
    with %Pagination{} = pagination <- StarWars.list_planets(params) do
      response_body = PlanetSerializer.serialize(pagination)

      conn
      |> put_status(:ok)
      |> json(response_body)
    end
  end
end

defmodule StarWarsAPI.V1.PlanetController do
  use StarWarsAPI, :controller

  alias CleanArchitecture.Pagination
  alias StarWars.Entities.Planet
  alias StarWarsAPI.V1.PlanetSerializer

  def index(conn, %{} = params) do
    with %Pagination{} = pagination <- StarWars.list_planets(params) do
      response_body = PlanetSerializer.serialize(pagination)

      conn
      |> put_status(:ok)
      |> json(response_body)
    end
  end

  def show(conn, %{"id" => id}) do
    with %Planet{} = planet <- StarWars.get_planet!(%{id: id}) do
      response_body = PlanetSerializer.serialize(planet)

      conn
      |> put_status(:ok)
      |> json(response_body)
    end
  end

  def delete(conn, %{"id" => id}) do
    attrs = %{
      id: id,
      deleted_at: DateTime.now!("Etc/UTC")
    }

    with {:ok, %Planet{}} <- StarWars.delete_planet(attrs) do
      send_resp(conn, 204, "")
    end
  end
end

defmodule StarWarsAPI.V1.PlanetSerializer do
  @moduledoc """
  Planet serializer is responsible to convert the record to map,
  applying all the changes needed to the record be exposed to the Web API.
  """

  alias StarWars.Entities.Planet

  alias StarWarsAPI.V1.ClimateSerializer
  alias StarWarsAPI.V1.MovieSerializer
  alias StarWarsAPI.V1.TerrainSerializer

  def serialize(%Planet{} = planet) do
    %{
      data: serialize(planet, :without_root_key)
    }
  end

  def serialize(%CleanArchitecture.Pagination{entries: entries} = pagination) do
    serialized_planets = Enum.map(entries, &serialize(&1, :without_root_key))

    %{
      data: serialized_planets,
      meta: pagination |> Map.from_struct() |> Map.delete(:entries)
    }
  end

  def serialize(nil, :without_root_key), do: nil

  def serialize(%Planet{} = planet, :without_root_key) do
    %{
      id: planet.id,
      name: planet.name,
      climates: ClimateSerializer.serialize(planet.climates),
      terrains: TerrainSerializer.serialize(planet.terrains),
      movies: MovieSerializer.serialize(planet.movies),
      inserted_at: planet.inserted_at,
      updated_at: planet.updated_at
    }
  end
end

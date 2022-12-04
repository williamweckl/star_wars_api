defmodule StarWarsAPI.V1.TerrainSerializer do
  @moduledoc """
  Terrain serializer is responsible to convert the record to map,
  applying all the changes needed to the record be exposed to the Web API.
  """

  alias StarWars.Entities.Terrain

  def serialize(%Terrain{} = terrain) do
    %{
      data: serialize(terrain, :without_root_key)
    }
  end

  def serialize(%CleanArchitecture.Pagination{entries: entries} = pagination) do
    serialized_terrains = Enum.map(entries, &serialize(&1, :without_root_key))

    %{
      data: serialized_terrains,
      meta: pagination |> Map.from_struct() |> Map.delete(:entries)
    }
  end

  def serialize(entries) when is_list(entries) do
    Enum.map(entries, &serialize(&1, :without_root_key))
  end

  def serialize(nil, :without_root_key), do: nil

  def serialize(%Terrain{} = terrain, :without_root_key) do
    %{
      id: terrain.id,
      name: terrain.name,
      inserted_at: terrain.inserted_at,
      updated_at: terrain.updated_at
    }
  end
end

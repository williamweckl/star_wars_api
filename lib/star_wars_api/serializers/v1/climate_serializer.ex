defmodule StarWarsAPI.V1.ClimateSerializer do
  @moduledoc """
  Climate serializer is responsible to convert the record to map,
  applying all the changes needed to the record be exposed to the Web API.
  """

  alias StarWars.Entities.Climate

  def serialize(%Climate{} = climate) do
    %{
      data: serialize(climate, :without_root_key)
    }
  end

  def serialize(%CleanArchitecture.Pagination{entries: entries} = pagination) do
    serialized_climates = Enum.map(entries, &serialize(&1, :without_root_key))

    %{
      data: serialized_climates,
      meta: pagination |> Map.from_struct() |> Map.delete(:entries)
    }
  end

  def serialize(entries) when is_list(entries) do
    Enum.map(entries, &serialize(&1, :without_root_key))
  end

  def serialize(nil, :without_root_key), do: nil

  def serialize(%Climate{} = climate, :without_root_key) do
    %{
      id: climate.id,
      name: climate.name,
      inserted_at: climate.inserted_at,
      updated_at: climate.updated_at
    }
  end
end

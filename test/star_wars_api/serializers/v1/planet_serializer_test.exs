defmodule StarWarsAPI.V1.PlanetSerializerTest do
  use StarWars.DataCase

  alias StarWars.Repo
  alias StarWarsAPI.V1.PlanetSerializer

  alias StarWarsAPI.V1.ClimateSerializer
  alias StarWarsAPI.V1.MovieSerializer
  alias StarWarsAPI.V1.TerrainSerializer

  defp fixture(attrs \\ %{}) do
    Factory.insert(:planet, attrs)
  end

  describe "serialize/1" do
    test "returns serialized record with root key" do
      record = fixture() |> Repo.preload([:climates, :terrains, :movies])

      assert PlanetSerializer.serialize(record) == %{
               data: %{
                 id: record.id,
                 name: record.name,
                 climates: ClimateSerializer.serialize(record.climates),
                 terrains: TerrainSerializer.serialize(record.terrains),
                 movies: MovieSerializer.serialize(record.movies),
                 inserted_at: record.inserted_at,
                 updated_at: record.updated_at
               }
             }
    end

    test "returns serialized records with root key for pagination" do
      record_one = fixture() |> Repo.preload([:climates, :terrains, :movies])
      record_two = fixture() |> Repo.preload([:climates, :terrains, :movies])

      pagination = %CleanArchitecture.Pagination{
        entries: [record_one, record_two],
        page_number: 1,
        page_size: 10,
        total_entries: 2,
        total_pages: 1
      }

      assert PlanetSerializer.serialize(pagination) == %{
               data: [
                 %{
                   id: record_one.id,
                   name: record_one.name,
                   climates: ClimateSerializer.serialize(record_one.climates),
                   terrains: TerrainSerializer.serialize(record_one.terrains),
                   movies: MovieSerializer.serialize(record_one.movies),
                   inserted_at: record_one.inserted_at,
                   updated_at: record_one.updated_at
                 },
                 %{
                   id: record_two.id,
                   name: record_two.name,
                   climates: ClimateSerializer.serialize(record_two.climates),
                   terrains: TerrainSerializer.serialize(record_two.terrains),
                   movies: MovieSerializer.serialize(record_two.movies),
                   inserted_at: record_two.inserted_at,
                   updated_at: record_two.updated_at
                 }
               ],
               meta: %{
                 page_number: 1,
                 page_size: 10,
                 total_entries: 2,
                 total_pages: 1
               }
             }
    end
  end

  describe "serialize/2" do
    test "returns serialized record without root key" do
      record = fixture() |> Repo.preload([:climates, :terrains, :movies])

      assert PlanetSerializer.serialize(record, :without_root_key) == %{
               id: record.id,
               name: record.name,
               climates: ClimateSerializer.serialize(record.climates),
               terrains: TerrainSerializer.serialize(record.terrains),
               movies: MovieSerializer.serialize(record.movies),
               inserted_at: record.inserted_at,
               updated_at: record.updated_at
             }
    end

    test "returns nil" do
      assert PlanetSerializer.serialize(nil, :without_root_key) == nil
    end
  end
end

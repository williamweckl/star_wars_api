defmodule StarWarsAPI.V1.TerrainSerializerTest do
  use StarWars.DataCase

  alias StarWarsAPI.V1.TerrainSerializer

  defp fixture(attrs \\ %{}) do
    Factory.insert(:terrain, attrs)
  end

  describe "serialize/1" do
    test "returns serialized record with root key" do
      record = fixture()

      assert TerrainSerializer.serialize(record) == %{
               data: %{
                 id: record.id,
                 name: record.name,
                 inserted_at: record.inserted_at,
                 updated_at: record.updated_at
               }
             }
    end

    test "returns serialized records with root key for pagination" do
      record_one = fixture()
      record_two = fixture()

      pagination = %CleanArchitecture.Pagination{
        entries: [record_one, record_two],
        page_number: 1,
        page_size: 10,
        total_entries: 2,
        total_pages: 1
      }

      assert TerrainSerializer.serialize(pagination) == %{
               data: [
                 %{
                   id: record_one.id,
                   name: record_one.name,
                   inserted_at: record_one.inserted_at,
                   updated_at: record_one.updated_at
                 },
                 %{
                   id: record_two.id,
                   name: record_two.name,
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
      record = fixture()

      assert TerrainSerializer.serialize(record, :without_root_key) == %{
               id: record.id,
               name: record.name,
               inserted_at: record.inserted_at,
               updated_at: record.updated_at
             }
    end

    test "returns nil" do
      assert TerrainSerializer.serialize(nil, :without_root_key) == nil
    end
  end
end

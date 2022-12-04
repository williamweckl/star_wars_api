defmodule StarWarsAPI.V1.MovieSerializerTest do
  use StarWars.DataCase

  alias StarWarsAPI.V1.MovieSerializer

  alias StarWarsAPI.V1.MovieDirectorSerializer

  defp fixture(attrs \\ %{}) do
    Factory.insert(:movie, attrs)
  end

  describe "serialize/1" do
    test "returns serialized record with root key" do
      record = fixture()

      assert MovieSerializer.serialize(record) == %{
               data: %{
                 id: record.id,
                 title: record.title,
                 release_date: record.release_date,
                 director: MovieDirectorSerializer.serialize(record.director),
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

      assert MovieSerializer.serialize(pagination) == %{
               data: [
                 %{
                   id: record_one.id,
                   title: record_one.title,
                   release_date: record_one.release_date,
                   director: MovieDirectorSerializer.serialize(record_one.director),
                   inserted_at: record_one.inserted_at,
                   updated_at: record_one.updated_at
                 },
                 %{
                   id: record_two.id,
                   title: record_two.title,
                   release_date: record_two.release_date,
                   director: MovieDirectorSerializer.serialize(record_two.director),
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

      assert MovieSerializer.serialize(record, :without_root_key) == %{
               id: record.id,
               title: record.title,
               release_date: record.release_date,
               director: MovieDirectorSerializer.serialize(record.director),
               inserted_at: record.inserted_at,
               updated_at: record.updated_at
             }
    end

    test "returns nil" do
      assert MovieSerializer.serialize(nil, :without_root_key) == nil
    end
  end
end

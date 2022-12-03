defmodule StarWars.Interactors.Planet.UpsertTest do
  use StarWars.DataCase

  alias StarWars.Entities.Planet

  alias StarWars.Interactors.Planet.Upsert
  alias StarWars.Repo

  @valid_attrs %{
    name: "Tatooine",
    integration_source:
      StarWars.Enums.IntegrationSource.__enum_map__() |> Keyword.keys() |> Enum.random(),
    integration_id: "#{:rand.uniform(999_999_999)}",
    climates: [],
    terrains: [],
    movies: []
  }

  defp planet_fixture(attrs) do
    Factory.insert(:planet, attrs)
  end

  defp assert_has_upserted_planet_attrs(planet) do
    assert_match = fn planet ->
      assert planet.name == @valid_attrs.name
      assert "#{planet.integration_source}" == "#{@valid_attrs.integration_source}"
      assert planet.integration_id == @valid_attrs.integration_id
    end

    assert_match.(planet)

    persisted_planet = Repo.reload!(planet)
    assert_match.(persisted_planet)
  end

  describe "call/1" do
    test "creates a planet when planet does not exist yet" do
      assert Repo.aggregate(Planet, :count, :id) == 0

      assert {:ok, %Planet{} = planet} = Upsert.call(@valid_attrs)

      assert_has_upserted_planet_attrs(planet)

      assert Repo.aggregate(Planet, :count, :id) == 1
    end

    test "creates a planet with associations when planet does not exist yet" do
      assert Repo.aggregate(Planet, :count, :id) == 0

      climates = Factory.insert_list(2, :climate)
      movies = Factory.insert_list(3, :movie)
      terrains = Factory.insert_list(4, :terrain)

      attrs =
        @valid_attrs
        |> Map.put(:climates, climates)
        |> Map.put(:movies, movies)
        |> Map.put(:terrains, terrains)

      assert {:ok, %Planet{} = planet} = Upsert.call(attrs)

      assert_has_upserted_planet_attrs(planet)

      assert Enum.sort(planet.climates) == Enum.sort(climates)
      assert Enum.sort(planet.movies) == Enum.sort(movies)
      assert Enum.sort(planet.terrains) == Enum.sort(terrains)

      reloaded_planet = planet |> Repo.reload!() |> Repo.preload([:climates, :terrains, :movies])

      assert Enum.sort(reloaded_planet.climates) == Enum.sort(climates)
      assert Enum.sort(reloaded_planet.movies) == Enum.sort(movies |> Repo.reload!())
      assert Enum.sort(reloaded_planet.terrains) == Enum.sort(terrains)

      assert Repo.aggregate(Planet, :count, :id) == 1
    end

    test "updates a planet when planet already exists" do
      planet_fixture(%{
        integration_source: @valid_attrs.integration_source,
        integration_id: @valid_attrs.integration_id
      })

      assert Repo.aggregate(Planet, :count, :id) == 1

      assert {:ok, %Planet{} = planet} = Upsert.call(@valid_attrs)

      assert_has_upserted_planet_attrs(planet)

      assert Repo.aggregate(Planet, :count, :id) == 1
    end

    test "updates a planet when planet already exists but the name contains empty spaces" do
      planet_fixture(%{
        integration_source: @valid_attrs.integration_source,
        integration_id: @valid_attrs.integration_id
      })

      assert Repo.aggregate(Planet, :count, :id) == 1

      assert {:ok, %Planet{} = planet} =
               @valid_attrs |> Map.put(:name, " #{@valid_attrs.name}  ") |> Upsert.call()

      assert_has_upserted_planet_attrs(planet)

      assert Repo.aggregate(Planet, :count, :id) == 1
    end

    test "updates a planet when planet already exists but the name is lower cased" do
      planet_fixture(%{
        integration_source: @valid_attrs.integration_source,
        integration_id: @valid_attrs.integration_id
      })

      assert Repo.aggregate(Planet, :count, :id) == 1

      assert {:ok, %Planet{} = planet} =
               @valid_attrs |> Map.put(:name, String.downcase(@valid_attrs.name)) |> Upsert.call()

      assert_has_upserted_planet_attrs(planet)

      assert Repo.aggregate(Planet, :count, :id) == 1
    end

    test "updates a planet when planet already exists removing existent associations" do
      climate_one = Factory.insert(:climate)
      climate_two = Factory.insert(:climate)
      terrain_one = Factory.insert(:terrain)
      terrain_two = Factory.insert(:terrain)
      movie_one = Factory.insert(:movie)
      movie_two = Factory.insert(:movie)

      before_update_climates = [climate_one, climate_two]
      before_update_terrains = [terrain_one, terrain_two]
      before_update_movies = [movie_one, movie_two]

      {:ok, created_planet} =
        Upsert.call(%{
          @valid_attrs
          | climates: before_update_climates,
            terrains: before_update_terrains,
            movies: before_update_movies
        })

      assert Repo.aggregate(Planet, :count, :id) == 1

      attrs =
        @valid_attrs
        |> Map.put(:climates, [climate_one])
        |> Map.put(:terrains, [terrain_one])
        |> Map.put(:movies, [movie_one])

      assert {:ok, %Planet{} = planet} = Upsert.call(attrs)

      assert planet.id == created_planet.id
      assert_has_upserted_planet_attrs(planet)

      assert planet.climates == [climate_one]
      assert planet.movies == [movie_one]
      assert planet.terrains == [terrain_one]

      reloaded_planet = planet |> Repo.reload!() |> Repo.preload([:climates, :terrains, :movies])
      assert reloaded_planet.climates == [climate_one]
      assert reloaded_planet.movies == [Repo.reload!(movie_one)]
      assert reloaded_planet.terrains == [terrain_one]

      # Must not delete not used records, only the association between planet and the record
      assert Repo.reload!(climate_two)
      assert Repo.reload!(terrain_two)
      assert Repo.reload!(movie_two)

      assert Repo.aggregate(Planet, :count, :id) == 1
    end

    test "does not create planet when attrs are invalid" do
      attrs = Map.merge(@valid_attrs, %{name: String.duplicate("a", 61)})

      assert Repo.aggregate(Planet, :count, :id) == 0

      assert {:error, %Ecto.Changeset{} = changeset} = Upsert.call(attrs)

      assert "should be at most 60 character(s)" in errors_on(changeset).name

      assert Repo.aggregate(Planet, :count, :id) == 0
    end

    test "does not update when attrs are invalid" do
      planet =
        planet_fixture(%{
          integration_source: @valid_attrs.integration_source,
          integration_id: @valid_attrs.integration_id
        })

      attrs = Map.merge(@valid_attrs, %{name: String.duplicate("a", 61)})

      assert {:error, %Ecto.Changeset{} = changeset} = Upsert.call(attrs)

      assert "should be at most 60 character(s)" in errors_on(changeset).name

      reloaded_planet = Repo.reload(planet)

      assert reloaded_planet.name == planet.name
    end

    test "creates a planet when planet with integration attrs exists but was deleted" do
      deleted_planet =
        planet_fixture(%{
          integration_source: @valid_attrs.integration_source,
          integration_id: @valid_attrs.integration_id,
          deleted_at: DateTime.now!("Etc/UTC")
        })

      assert Repo.aggregate(Planet, :count, :id) == 1

      assert {:ok, %Planet{} = planet} = Upsert.call(@valid_attrs)

      assert planet.id != deleted_planet.id
      assert planet.name == @valid_attrs.name
      assert planet.deleted_at == nil

      assert Repo.aggregate(Planet, :count, :id) == 2
    end
  end
end

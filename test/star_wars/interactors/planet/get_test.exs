defmodule StarWars.Interactors.Planet.GetTest do
  use StarWars.DataCase

  alias StarWars.Interactors.Planet.Get
  alias StarWars.Repo

  def fixture(attrs \\ %{}) do
    Factory.insert(:planet, attrs)
  end

  describe "call/1" do
    test "returns a planet by the given id" do
      planet = fixture()
      input = %{id: planet.id}

      assert Get.call(input) ==
               planet
               |> Repo.reload!()
               |> Repo.preload([:climates, :terrains])
               |> Repo.preload(movies: :director)
    end

    test "does not return deleted associations" do
      climate = Factory.insert(:climate)
      deleted_climate = Factory.insert(:climate, %{deleted_at: DateTime.now!("Etc/UTC")})
      climates = [climate, deleted_climate]

      terrain = Factory.insert(:terrain)
      deleted_terrain = Factory.insert(:terrain, %{deleted_at: DateTime.now!("Etc/UTC")})
      terrains = [terrain, deleted_terrain]

      movie = Factory.insert(:movie)
      deleted_movie = Factory.insert(:movie, %{deleted_at: DateTime.now!("Etc/UTC")})
      movies = [movie, deleted_movie]

      {:ok, planet} =
        StarWars.upsert_planet(%{
          name: "Tatooine",
          integration_source: :star_wars_public_api,
          integration_id: "1",
          climates: climates,
          terrains: terrains,
          movies: movies
        })

      loaded_planet = Get.call(%{id: planet.id})

      loaded_planet_climate_ids = Enum.map(loaded_planet.climates, fn climate -> climate.id end)
      refute deleted_climate.id in loaded_planet_climate_ids

      loaded_planet_terrain_ids = Enum.map(loaded_planet.terrains, fn terrain -> terrain.id end)
      refute deleted_terrain.id in loaded_planet_terrain_ids

      loaded_planet_movie_ids = Enum.map(loaded_planet.movies, fn movie -> movie.id end)
      refute deleted_movie.id in loaded_planet_movie_ids
    end

    test "raises cast error when id is in an invalid format" do
      input = %{id: "invalid"}

      assert_raise Ecto.Query.CastError, fn ->
        Get.call(input)
      end
    end

    test "raises not found error when id is not existent" do
      input = %{id: Ecto.UUID.generate()}

      assert_raise Ecto.NoResultsError, fn ->
        Get.call(input)
      end
    end

    test "raises not found error when planet is deleted" do
      planet = fixture(%{deleted_at: DateTime.utc_now()})
      input = %{id: planet.id}

      assert_raise Ecto.NoResultsError, fn ->
        Get.call(input)
      end
    end
  end
end

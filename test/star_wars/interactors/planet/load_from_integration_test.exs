defmodule StarWars.Interactors.Planet.LoadFromIntegrationTest do
  use StarWars.DataCase

  alias StarWars.Entities.Climate
  alias StarWars.Entities.Movie
  alias StarWars.Entities.MovieDirector
  alias StarWars.Entities.Planet
  alias StarWars.Entities.Terrain

  alias StarWars.Interactors.Planet.LoadFromIntegration
  alias StarWars.Repo

  alias StarWars.IntegrationSource.Adapters

  @valid_attrs %{
    integration_source: :mock,
    integration_id: "#{:rand.uniform(999_999_999)}"
  }

  defp assert_has_upserted_planet_attrs(planet) do
    {:ok, mocked_planet_response} = Adapters.Mock.get_planet(@valid_attrs.integration_id)

    assert_match = fn planet ->
      assert planet.name == mocked_planet_response.name
      assert "#{planet.integration_source}" == "#{mocked_planet_response.integration_source}"
      assert planet.integration_id == mocked_planet_response.integration_id

      assert Enum.map(planet.climates, fn climate -> climate.id end) ==
               Enum.map(mocked_planet_response.climates, fn climate -> climate.id end)

      assert Enum.map(planet.terrains, fn terrain -> terrain.id end) ==
               Enum.map(mocked_planet_response.terrains, fn terrain -> terrain.id end)

      assert Enum.map(planet.movies, fn movie -> movie.title end) ==
               Enum.map(mocked_planet_response.movies, fn movie -> movie.title end)
    end

    assert_match.(planet)

    persisted_planet = Repo.reload!(planet) |> Repo.preload([:climates, :movies, :terrains])
    assert_match.(persisted_planet)
  end

  describe "call/1" do
    test "creates planet, climate, terrain, movie and movie director when records does not exist yet" do
      assert Repo.aggregate(Climate, :count, :id) == 0
      assert Repo.aggregate(Planet, :count, :id) == 0
      assert Repo.aggregate(Movie, :count, :id) == 0
      assert Repo.aggregate(MovieDirector, :count, :id) == 0
      assert Repo.aggregate(Terrain, :count, :id) == 0

      assert {:ok, %Planet{} = planet} = LoadFromIntegration.call(@valid_attrs)

      assert_has_upserted_planet_attrs(planet)

      assert Repo.aggregate(Climate, :count, :id) == 1
      assert Repo.aggregate(Planet, :count, :id) == 1
      assert Repo.aggregate(Movie, :count, :id) == 1
      assert Repo.aggregate(MovieDirector, :count, :id) == 1
      assert Repo.aggregate(Terrain, :count, :id) == 1
    end

    test "updates planet, climate, terrain, movie and movie director when records already exists" do
      LoadFromIntegration.call(@valid_attrs)

      assert Repo.aggregate(Climate, :count, :id) == 1
      assert Repo.aggregate(Planet, :count, :id) == 1
      assert Repo.aggregate(Movie, :count, :id) == 1
      assert Repo.aggregate(MovieDirector, :count, :id) == 1
      assert Repo.aggregate(Terrain, :count, :id) == 1

      assert {:ok, %Planet{} = planet} = LoadFromIntegration.call(@valid_attrs)

      assert_has_upserted_planet_attrs(planet)

      assert Repo.aggregate(Climate, :count, :id) == 1
      assert Repo.aggregate(Planet, :count, :id) == 1
      assert Repo.aggregate(Movie, :count, :id) == 1
      assert Repo.aggregate(MovieDirector, :count, :id) == 1
      assert Repo.aggregate(Terrain, :count, :id) == 1
    end

    test "returns error when planet is not found" do
      assert {:error, %StarWars.HTTPClientResponse{status_code: 404, body: "", headers: []}} ==
               LoadFromIntegration.call(%{@valid_attrs | integration_id: "not_found"})
    end

    test "returns error when planet request returns error" do
      assert {:error, %StarWars.HTTPClientResponse{status_code: 500, body: "", headers: []}} ==
               LoadFromIntegration.call(%{@valid_attrs | integration_id: "error"})
    end

    test "returns error when planet request returns invalid data" do
      assert {:error, :invalid_response} ==
               LoadFromIntegration.call(%{@valid_attrs | integration_id: "not_json"})
    end

    test "returns error when planet request returns unhandled_response" do
      assert {:error, :unhandled_response} ==
               LoadFromIntegration.call(%{@valid_attrs | integration_id: "unhandled_response"})
    end
  end
end

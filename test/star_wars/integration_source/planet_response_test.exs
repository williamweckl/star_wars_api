defmodule StarWars.IntegrationSource.PlanetResponseTest do
  use StarWars.DataCase

  alias StarWars.IntegrationSource.ClimateResponse
  alias StarWars.IntegrationSource.MovieDirectorResponse
  alias StarWars.IntegrationSource.MovieResponse
  alias StarWars.IntegrationSource.PlanetResponse
  alias StarWars.IntegrationSource.TerrainResponse

  describe "struct" do
    test "defaults attributes to nil" do
      response = %PlanetResponse{}

      assert nil == response.name
      assert nil == response.integration_source
      assert nil == response.integration_id
      assert nil == response.climates
      assert nil == response.terrains
      assert nil == response.movies
    end

    test "accepts attributes" do
      response = %PlanetResponse{
        name: "Tatooine",
        integration_source: "star_wars_public_api",
        integration_id: "1",
        climates: [
          %ClimateResponse{
            id: "arid",
            name: "Arid",
            integration_source: "star_wars_public_api"
          }
        ],
        terrains: [
          %TerrainResponse{
            id: "ocean",
            name: "Ocean",
            integration_source: "star_wars_public_api"
          }
        ],
        movies: [
          %MovieResponse{
            title: "A New Hope",
            release_date: ~D[2000-01-01],
            integration_source: "star_wars_public_api",
            integration_id: "1",
            director: %MovieDirectorResponse{
              name: "George Lucas",
              integration_source: "star_wars_public_api"
            }
          }
        ]
      }

      assert "Tatooine" == response.name
      assert "star_wars_public_api" == response.integration_source
      assert "1" == response.integration_id

      assert [
               %ClimateResponse{
                 id: "arid",
                 name: "Arid",
                 integration_source: "star_wars_public_api"
               }
             ] == response.climates

      assert [
               %TerrainResponse{
                 id: "ocean",
                 name: "Ocean",
                 integration_source: "star_wars_public_api"
               }
             ] == response.terrains

      assert [
               %MovieResponse{
                 title: "A New Hope",
                 release_date: ~D[2000-01-01],
                 integration_source: "star_wars_public_api",
                 integration_id: "1",
                 director: %MovieDirectorResponse{
                   name: "George Lucas",
                   integration_source: "star_wars_public_api"
                 }
               }
             ] == response.movies
    end
  end
end

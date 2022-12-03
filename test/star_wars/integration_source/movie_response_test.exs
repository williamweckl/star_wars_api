defmodule StarWars.IntegrationSource.MovieResponseTest do
  use StarWars.DataCase

  alias StarWars.IntegrationSource.MovieDirectorResponse
  alias StarWars.IntegrationSource.MovieResponse

  describe "struct" do
    test "defaults attributes to nil" do
      response = %MovieResponse{}

      assert nil == response.title
      assert nil == response.release_date
      assert nil == response.integration_source
      assert nil == response.integration_id
      assert nil == response.director
    end

    test "accepts attributes" do
      response = %MovieResponse{
        title: "A New Hope",
        release_date: ~D[2000-01-01],
        integration_source: "star_wars_public_api",
        integration_id: "1",
        director: %MovieDirectorResponse{
          name: "George Lucas",
          integration_source: "star_wars_public_api"
        }
      }

      assert "A New Hope" == response.title
      assert ~D[2000-01-01] == response.release_date
      assert "star_wars_public_api" == response.integration_source
      assert "1" == response.integration_id

      assert %MovieDirectorResponse{
               name: "George Lucas",
               integration_source: "star_wars_public_api"
             } == response.director
    end
  end
end

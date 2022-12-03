defmodule StarWars.IntegrationSource.MovieDirectorResponseTest do
  use StarWars.DataCase

  alias StarWars.IntegrationSource.MovieDirectorResponse

  describe "struct" do
    test "defaults attributes to nil" do
      response = %MovieDirectorResponse{}

      assert nil == response.name
      assert nil == response.integration_source
    end

    test "accepts attributes" do
      response = %MovieDirectorResponse{
        name: "George Lucas",
        integration_source: "star_wars_public_api"
      }

      assert "George Lucas" == response.name
      assert "star_wars_public_api" == response.integration_source
    end
  end
end

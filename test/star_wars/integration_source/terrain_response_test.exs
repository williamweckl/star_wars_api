defmodule StarWars.IntegrationSource.TerrainResponseTest do
  use StarWars.DataCase

  alias StarWars.IntegrationSource.TerrainResponse

  describe "struct" do
    test "defaults attributes to nil" do
      response = %TerrainResponse{}

      assert nil == response.id
      assert nil == response.name
      assert nil == response.integration_source
    end

    test "accepts attributes" do
      response = %TerrainResponse{
        id: "ocean",
        name: "Ocean",
        integration_source: "star_wars_public_api"
      }

      assert "ocean" == response.id
      assert "Ocean" == response.name
      assert "star_wars_public_api" == response.integration_source
    end
  end
end

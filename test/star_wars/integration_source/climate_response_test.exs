defmodule StarWars.IntegrationSource.ClimateResponseTest do
  use StarWars.DataCase

  alias StarWars.IntegrationSource.ClimateResponse

  describe "struct" do
    test "defaults attributes to nil" do
      response = %ClimateResponse{}

      assert nil == response.id
      assert nil == response.name
      assert nil == response.integration_source
    end

    test "accepts attributes" do
      response = %ClimateResponse{
        id: "arid",
        name: "Arid",
        integration_source: "star_wars_public_api"
      }

      assert "arid" == response.id
      assert "Arid" == response.name
      assert "star_wars_public_api" == response.integration_source
    end
  end
end

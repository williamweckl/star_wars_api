defmodule Mix.Tasks.LoadPlanetFromIntegrationTest do
  use StarWars.DataCase

  alias Mix.Tasks.LoadPlanetFromIntegration

  import Mock

  @integration_source Application.compile_env!(:star_wars, :integration_source)

  describe "run/1" do
    test "calls use case with the right parameters" do
      with_mock(
        StarWars,
        load_planet_from_integration: fn _attrs ->
          "fake_response"
        end
      ) do
        assert "fake_response" == LoadPlanetFromIntegration.run(["123"])

        assert_called_exactly(
          StarWars.load_planet_from_integration(%{
            integration_source: @integration_source,
            integration_id: "123"
          }),
          1
        )
      end
    end
  end
end

defmodule StarWars.IntegrationSource.PlanetResponse do
  @moduledoc """
  Planet Response struct.

  Every integration source that retrieves a planet needs to respond with this struct.
  """

  defstruct [:name, :integration_source, :integration_id, :climates, :terrains, :movies]
end

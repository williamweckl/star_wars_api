defmodule StarWars.IntegrationSource.TerrainResponse do
  @moduledoc """
  Terrain Response struct.

  Every integration source that retrieves a terrain needs to respond with this struct.
  """

  defstruct [:id, :name, :integration_source]
end

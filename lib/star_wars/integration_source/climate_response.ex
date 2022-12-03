defmodule StarWars.IntegrationSource.ClimateResponse do
  @moduledoc """
  Climate Response struct.

  Every integration source that retrieves a climate needs to respond with this struct.
  """

  defstruct [:id, :name, :integration_source]
end

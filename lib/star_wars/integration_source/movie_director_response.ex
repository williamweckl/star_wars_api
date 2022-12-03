defmodule StarWars.IntegrationSource.MovieDirectorResponse do
  @moduledoc """
  Movie Director Response struct.

  Every integration source that retrieves a movie director needs to respond with this struct.
  """

  defstruct [:name, :integration_source]
end

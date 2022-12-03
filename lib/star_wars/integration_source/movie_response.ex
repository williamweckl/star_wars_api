defmodule StarWars.IntegrationSource.MovieResponse do
  @moduledoc """
  Movie Response struct.

  Every integration source that retrieves a movie needs to respond with this struct.
  """

  defstruct [:title, :release_date, :integration_source, :integration_id, :director]
end

defmodule StarWars.HTTPClientResponse do
  @moduledoc """
  HTTP Response struct to be used by the HTTP client.
  """

  defstruct [:status_code, :body, :headers]
end

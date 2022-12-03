defmodule Mix.Tasks.LoadPlanetFromIntegration do
  @moduledoc """
  The task responsible for loading a planet from the integration by the ID received.

  You can run the task by using the command: mix load_planet_from_integration <id>

  Do not forget to pass the ID to the task, if it is missing and error will be returned.
  """

  @shortdoc "Loads a planet from the integration by its ID."
  @requirements ["app.start"]

  use Mix.Task

  require Logger

  @integration_source Application.compile_env!(:star_wars, :integration_source)

  @impl Mix.Task
  def run([integration_id]) do
    attrs = %{
      integration_source: @integration_source,
      integration_id: integration_id
    }

    response = StarWars.load_planet_from_integration(attrs)

    Logger.info("Planet was loaded successfully!")

    response
  end
end

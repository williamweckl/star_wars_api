defmodule StarWars.Contracts.Planet.LoadFromIntegration do
  @moduledoc """
  Input pattern necessary to perform a planet load from an integration.

  ## Fields:

  - `integration_source` :: The integration source used to load the planet.
  - `integration_id` :: The ID at the integration source.
  """
  use CleanArchitecture.Contract

  embedded_schema do
    field :integration_source, StarWars.Enums.IntegrationSource
    field :integration_id, :string
  end

  @fields [
    :integration_source,
    :integration_id
  ]

  @required @fields

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, @fields)
    |> validate_required(@required)
  end
end

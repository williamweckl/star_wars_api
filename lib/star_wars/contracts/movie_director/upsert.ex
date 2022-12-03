defmodule StarWars.Contracts.MovieDirector.Upsert do
  @moduledoc """
  Input pattern necessary to perform a movie director upsert.

  ## Fields:

  - `name` :: Movie director name.
  - `integration_source` :: The integration source used to load the movie director.
  """
  use CleanArchitecture.Contract

  embedded_schema do
    field :name, :string
    field :integration_source, StarWars.Enums.IntegrationSource
  end

  @fields [
    :name,
    :integration_source
  ]

  @required @fields

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, @fields)
    |> validate_required(@required)
    |> validate_length(:name, max: 255)
  end
end

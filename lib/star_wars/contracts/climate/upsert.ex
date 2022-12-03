defmodule StarWars.Contracts.Climate.Upsert do
  @moduledoc """
  Input pattern necessary to perform a climate upsert.

  ## Fields:

  - `id` :: Climate ID.
  - `name` :: Climate name.
  - `integration_source` :: The integration source used to load the movie.
  """
  use CleanArchitecture.Contract

  embedded_schema do
    field :id, :string
    field :name, :string
    field :integration_source, StarWars.Enums.IntegrationSource
  end

  @fields [
    :id,
    :name,
    :integration_source
  ]

  @required @fields

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, @fields)
    |> validate_required(@required)
    |> validate_length(:name, min: 2, max: 60)
  end
end

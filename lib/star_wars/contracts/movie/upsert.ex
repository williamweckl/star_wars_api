defmodule StarWars.Contracts.Movie.Upsert do
  @moduledoc """
  Input pattern necessary to perform a movie upsert.

  ## Fields:

  - `title` :: Movie title.
  - `release_date` :: The movie release date.
  - `integration_source` :: The integration source used to load the movie.
  - `integration_id` :: The ID at the integration source.
  - `director_id` :: The related director ID.
  """
  use CleanArchitecture.Contract

  embedded_schema do
    field :title, :string
    field :release_date, :date
    field :integration_source, StarWars.Enums.IntegrationSource
    field :integration_id, :string
    field :director_id, :binary_id
  end

  @fields [
    :title,
    :release_date,
    :integration_source,
    :integration_id,
    :director_id
  ]

  @required @fields

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, @fields)
    |> validate_required(@required)
    |> validate_length(:title, max: 255)
  end
end

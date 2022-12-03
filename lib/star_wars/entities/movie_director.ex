defmodule StarWars.Entities.MovieDirector do
  @moduledoc """
  Movie Director entity.

  The entity contains the mapped fields. It represents a real business entity and must be used only by Interactors.
  """

  use CleanArchitecture.Entity

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "movie_directors" do
    field :name, :string
    field :integration_source, StarWars.Enums.IntegrationSource

    field(:deleted_at, :utc_datetime_usec)
    timestamps(type: :utc_datetime_usec)
  end

  @fields [
    :name,
    :integration_source,
    :deleted_at
  ]

  @required_fields @fields -- [:deleted_at]

  @doc false
  def changeset do
    changeset(%__MODULE__{}, %{})
  end

  def changeset(%__MODULE__{} = movie_director) do
    changeset(movie_director, %{})
  end

  def changeset(%{} = attrs) do
    changeset(%__MODULE__{}, attrs)
  end

  def changeset(%__MODULE__{} = movie_director, %{} = attrs) do
    movie_director
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> validate_length(:name, max: 255)
  end
end

defmodule StarWars.Entities.Movie do
  @moduledoc """
  Movie entity.

  The entity contains the mapped fields. It represents a real business entity and must be used only by Interactors.
  """

  use CleanArchitecture.Entity

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "movies" do
    field :title, :string
    field :release_date, :date
    field :integration_source, StarWars.Enums.IntegrationSource
    field :integration_id, :string

    field(:deleted_at, :utc_datetime_usec)
    timestamps(type: :utc_datetime_usec)

    belongs_to :director, StarWars.Entities.MovieDirector, type: :binary_id
  end

  @fields [
    :title,
    :release_date,
    :integration_source,
    :integration_id,
    :director_id,
    :deleted_at
  ]

  @required_fields @fields -- [:integration_id, :deleted_at]

  @doc false
  def changeset do
    changeset(%__MODULE__{}, %{})
  end

  def changeset(%__MODULE__{} = movie) do
    changeset(movie, %{})
  end

  def changeset(%{} = attrs) do
    changeset(%__MODULE__{}, attrs)
  end

  def changeset(%__MODULE__{} = movie, %{} = attrs) do
    movie
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> validate_length(:title, max: 255)
    |> unique_constraint(:integration_id, name: "unique_movie_integration_id")
  end
end

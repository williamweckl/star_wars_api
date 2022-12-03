defmodule StarWars.Contracts.Planet.Upsert do
  @moduledoc """
  Input pattern necessary to perform a planet upsert.

  ## Fields:

  - `name` :: Planet name.
  - `integration_source` :: The integration source used to load the planet.
  - `integration_id` :: The ID at the integration source.
  - `climates` :: A list of climates related to the planet. Needs to have at least one climate and all the list records needs to have valid ids.
  - `movies` :: A list of movies related to the planet. Needs to have at least one movie and all the list records needs to have valid ids.
  - `terrains` :: A list of terrains related to the planet. Needs to have at least one terrain and all the list records needs to have valid ids.
  """
  use CleanArchitecture.Contract

  alias StarWars.Entities.Climate
  alias StarWars.Entities.Movie
  alias StarWars.Entities.Terrain

  embedded_schema do
    field :name, :string
    field :integration_source, StarWars.Enums.IntegrationSource
    field :integration_id, :string
    field :climates, {:array, :map}
    field :movies, {:array, :map}
    field :terrains, {:array, :map}
  end

  @fields [
    :name,
    :integration_source,
    :integration_id,
    :climates,
    :movies,
    :terrains
  ]

  @required @fields

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, @fields)
    |> validate_required(@required)
    |> validate_length(:name, max: 60)
    |> validate_list_length(:climates, min: 1)
    |> validate_list_length(:terrains, min: 1)
    |> validate_list_length(:movies, min: 1)
    |> validate_climates()
    |> validate_terrains()
    |> validate_movies()
  end

  defp validate_list_length(changeset, attribute, min: min) do
    value = get_field(changeset, attribute)

    if is_list(value) && length(value) < min do
      changeset |> add_error(attribute, "can't be blank")
    else
      changeset
    end
  end

  defp validate_climates(changeset) do
    climates = get_field(changeset, :climates) || []

    if Enum.all?(climates, &is_climate?(&1)) do
      changeset
    else
      changeset |> add_error(:climates, "is invalid")
    end
  end

  defp is_climate?(%Climate{id: "" <> _id}), do: true
  defp is_climate?(_something_different_from_valid_climate), do: false

  defp validate_terrains(changeset) do
    terrains = get_field(changeset, :terrains) || []

    if Enum.all?(terrains, &is_terrain?(&1)) do
      changeset
    else
      changeset |> add_error(:terrains, "is invalid")
    end
  end

  defp is_terrain?(%Terrain{id: "" <> _id}), do: true
  defp is_terrain?(_something_different_from_valid_terrain), do: false

  defp validate_movies(changeset) do
    movies = get_field(changeset, :movies) || []

    if Enum.all?(movies, &is_movie?(&1)) do
      changeset
    else
      changeset |> add_error(:movies, "is invalid")
    end
  end

  defp is_movie?(%Movie{id: "" <> _id}), do: true
  defp is_movie?(_something_different_from_valid_movie), do: false
end

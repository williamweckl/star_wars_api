defmodule StarWars.Entities.Planet do
  @moduledoc """
  Planet entity.

  The entity contains the mapped fields. It represents a real business entity and must be used only by Interactors.
  """

  use CleanArchitecture.Entity

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "planets" do
    field :name, :string
    field :integration_source, StarWars.Enums.IntegrationSource
    field :integration_id, :string

    field(:deleted_at, :utc_datetime_usec)
    timestamps(type: :utc_datetime_usec)

    many_to_many :climates, StarWars.Entities.Climate,
      join_through: "planets_climates",
      on_delete: :delete_all,
      on_replace: :delete,
      unique: true,
      where: [deleted_at: nil]

    many_to_many :movies, StarWars.Entities.Movie,
      join_through: "planets_movies",
      on_delete: :delete_all,
      on_replace: :delete,
      unique: true,
      where: [deleted_at: nil]

    many_to_many :terrains, StarWars.Entities.Terrain,
      join_through: "planets_terrains",
      on_delete: :delete_all,
      on_replace: :delete,
      unique: true,
      where: [deleted_at: nil]
  end

  @fields [
    :name,
    :integration_source,
    :integration_id,
    :deleted_at
  ]

  @required_fields @fields -- [:integration_id, :deleted_at]

  @doc false
  def changeset do
    changeset(%__MODULE__{}, %{})
  end

  def changeset(%__MODULE__{} = planet) do
    changeset(planet, %{})
  end

  def changeset(%{} = attrs) do
    changeset(%__MODULE__{}, attrs)
  end

  def changeset(%__MODULE__{} = planet, %{} = attrs) do
    planet
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> validate_length(:name, max: 60)
    |> unique_constraint(:integration_id, name: "unique_planet_integration_id")
  end
end

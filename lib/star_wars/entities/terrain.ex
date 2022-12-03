defmodule StarWars.Entities.Terrain do
  @moduledoc """
  Terrain entity.

  The entity contains the mapped fields. It represents a real business entity and must be used only by Interactors.
  """

  use CleanArchitecture.Entity

  @primary_key {:id, :string, autogenerate: false}
  schema "terrains" do
    field :name, :string
    field :integration_source, StarWars.Enums.IntegrationSource

    field(:deleted_at, :utc_datetime_usec)
    timestamps(type: :utc_datetime_usec)
  end

  @fields [
    :id,
    :name,
    :integration_source,
    :deleted_at
  ]

  @required_fields @fields -- [:deleted_at]

  @doc false
  def changeset do
    changeset(%__MODULE__{}, %{})
  end

  def changeset(%__MODULE__{} = terrain) do
    changeset(terrain, %{})
  end

  def changeset(%{} = attrs) do
    changeset(%__MODULE__{}, attrs)
  end

  def changeset(%__MODULE__{} = terrain, %{} = attrs) do
    terrain
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> validate_length(:name, min: 2, max: 60)
  end
end

defmodule StarWars.Contracts.Planet.Delete do
  @moduledoc """
  Input pattern necessary to perform a planet delete.

  ## Fields:

  - `id` :: The ID of the planet to be deleted. (required)
  - `deleted_at` :: Helps to minimize side effects of the interactor/use case. (required)
  """

  use CleanArchitecture.Contract

  embedded_schema do
    field :id, Ecto.UUID
    field :deleted_at, :utc_datetime_usec
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:id, :deleted_at])
    |> validate_required([:id, :deleted_at])
  end
end

defmodule StarWars.Contracts.Movie.Get do
  @moduledoc """
  Input pattern necessary to perform a movie get.

  ## Fields:

  - `id` :: Used to filter. (required)
  """

  use CleanArchitecture.Contract

  embedded_schema do
    field :id, Ecto.UUID
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:id])
    |> validate_required([:id])
  end
end

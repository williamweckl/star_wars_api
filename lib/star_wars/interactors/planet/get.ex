defmodule StarWars.Interactors.Planet.Get do
  @moduledoc """
  Get planet use case.

  Do not call this module directly, use always the StarWars module that is the boundary context.
  """
  use CleanArchitecture.Interactor

  alias StarWars.Entities.Planet
  alias StarWars.Repo

  @doc """
  Gets a planet.
  """
  def call(%{id: id}) do
    Planet
    |> filter_not_deleted()
    |> preload([:climates, :terrains])
    |> preload(movies: :director)
    |> Repo.get!(id)
  end

  defp filter_not_deleted(query) do
    where(query, [p], is_nil(p.deleted_at))
  end
end

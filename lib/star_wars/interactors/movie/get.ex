defmodule StarWars.Interactors.Movie.Get do
  @moduledoc """
  Get movie use case.

  Do not call this module directly, use always the StarWars module that is the boundary context.
  """
  use CleanArchitecture.Interactor

  alias StarWars.Entities.Movie
  alias StarWars.Repo

  @doc """
  Gets a movie.
  """
  def call(%{id: id}) do
    Movie
    |> filter_not_deleted()
    |> preload([:director])
    |> Repo.get!(id)
  end

  defp filter_not_deleted(query) do
    where(query, [p], is_nil(p.deleted_at))
  end
end

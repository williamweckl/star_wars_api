defmodule StarWars.Interactors.MovieDirector.Upsert do
  @moduledoc """
  Movie Director upsert use case.
  Do not call this module directly, use always the StarWars module that is the boundary context.

  ## General rules:

  - When a movie director with the given `name` already exist, it will be updated.
  - When a movie director with the given `name` does not exist, it will be created.
  """

  use CleanArchitecture.Interactor

  alias StarWars.Entities.MovieDirector
  alias StarWars.Repo

  @doc """
  Upserts a movie director.
  """
  def call(%{name: _name} = input) do
    input
    |> normalize_name()
    |> get_existent_movie_director()
    |> upsert_movie_director()
    |> handle_output()
  end

  defp normalize_name(%{name: name} = input) do
    normalized_name =
      name
      |> String.trim()
      |> String.split(" ")
      |> Enum.map_join(" ", &String.capitalize/1)

    input
    |> Map.put(:name, normalized_name)
  end

  defp get_existent_movie_director(%{name: name} = input) do
    existent_movie_director =
      MovieDirector |> where([t], is_nil(t.deleted_at)) |> Repo.get_by(name: name)

    input |> Map.put(:existent_movie_director, existent_movie_director)
  end

  defp upsert_movie_director(%{existent_movie_director: nil} = input) do
    input
    |> MovieDirector.changeset()
    |> Repo.insert()
  end

  defp upsert_movie_director(
         %{existent_movie_director: %MovieDirector{} = existent_movie_director} = input
       ) do
    existent_movie_director
    |> MovieDirector.changeset(input)
    |> Repo.update()
  end

  defp handle_output({:ok, %MovieDirector{} = movie_director}), do: {:ok, movie_director}
  defp handle_output({:error, %Ecto.Changeset{} = changeset}), do: {:error, changeset}
end

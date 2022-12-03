defmodule StarWars.Interactors.Movie.Upsert do
  @moduledoc """
  Movie upsert use case.
  Do not call this module directly, use always the StarWars module that is the boundary context.

  ## General rules:

  - When a movie with the given `integration_source` and `integration_id` already exist, it will be updated.
  - When a movie with the given `integration_source` and `integration_id` does not exist, it will be created.
  """

  use CleanArchitecture.Interactor

  alias StarWars.Entities.Movie
  alias StarWars.Repo

  @doc """
  Upserts a movie.
  """
  def call(%{} = input) do
    input
    |> normalize_title()
    |> get_existent_movie()
    |> upsert_movie()
    |> handle_output()
  end

  defp normalize_title(input) do
    normalized_title =
      input.title
      |> String.trim()
      |> String.split(" ")
      |> Enum.map_join(" ", &String.capitalize/1)

    input
    |> Map.put(:title, normalized_title)
  end

  defp get_existent_movie(input) do
    existent_movie =
      Movie
      |> where([t], is_nil(t.deleted_at))
      |> Repo.get_by(
        integration_source: input.integration_source,
        integration_id: input.integration_id
      )

    input |> Map.put(:existent_movie, existent_movie)
  end

  defp upsert_movie(%{existent_movie: nil} = input) do
    input
    |> Movie.changeset()
    |> Repo.insert()
  end

  defp upsert_movie(%{existent_movie: existent_movie} = input) do
    existent_movie
    |> Movie.changeset(input)
    |> Repo.update()
  end

  defp handle_output({:ok, movie}), do: {:ok, movie}
  defp handle_output({:error, changeset}), do: {:error, changeset}
end

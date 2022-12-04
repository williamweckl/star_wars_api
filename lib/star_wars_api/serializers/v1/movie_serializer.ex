defmodule StarWarsAPI.V1.MovieSerializer do
  @moduledoc """
  Movie serializer is responsible to convert the record to map,
  applying all the changes needed to the record be exposed to the Web API.
  """

  alias StarWars.Entities.Movie

  alias StarWarsAPI.V1.MovieDirectorSerializer

  def serialize(%Movie{} = movie) do
    %{
      data: serialize(movie, :without_root_key)
    }
  end

  def serialize(%CleanArchitecture.Pagination{entries: entries} = pagination) do
    serialized_movies = Enum.map(entries, &serialize(&1, :without_root_key))

    %{
      data: serialized_movies,
      meta: pagination |> Map.from_struct() |> Map.delete(:entries)
    }
  end

  def serialize(entries) when is_list(entries) do
    Enum.map(entries, &serialize(&1, :without_root_key))
  end

  def serialize(nil, :without_root_key), do: nil

  def serialize(%Movie{} = movie, :without_root_key) do
    %{
      id: movie.id,
      title: movie.title,
      release_date: movie.release_date,
      director: MovieDirectorSerializer.serialize(movie.director),
      inserted_at: movie.inserted_at,
      updated_at: movie.updated_at
    }
  end
end

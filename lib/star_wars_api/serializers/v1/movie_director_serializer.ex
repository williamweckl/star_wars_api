defmodule StarWarsAPI.V1.MovieDirectorSerializer do
  @moduledoc """
  Movie Director serializer is responsible to convert the record to map,
  applying all the changes needed to the record be exposed to the Web API.
  """

  alias StarWars.Entities.MovieDirector

  def serialize(%MovieDirector{} = movie_director) do
    %{
      data: serialize(movie_director, :without_root_key)
    }
  end

  def serialize(%CleanArchitecture.Pagination{entries: entries} = pagination) do
    serialized_movie_directors = Enum.map(entries, &serialize(&1, :without_root_key))

    %{
      data: serialized_movie_directors,
      meta: pagination |> Map.from_struct() |> Map.delete(:entries)
    }
  end

  def serialize(nil, :without_root_key), do: nil

  def serialize(%MovieDirector{} = movie_director, :without_root_key) do
    %{
      id: movie_director.id,
      name: movie_director.name,
      inserted_at: movie_director.inserted_at,
      updated_at: movie_director.updated_at
    }
  end
end

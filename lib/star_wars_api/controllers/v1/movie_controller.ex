defmodule StarWarsAPI.V1.MovieController do
  use StarWarsAPI, :controller

  alias StarWars.Entities.Movie
  alias StarWarsAPI.V1.MovieSerializer

  def show(conn, %{"id" => id}) do
    with %Movie{} = movie <- StarWars.get_movie!(%{id: id}) do
      response_body = MovieSerializer.serialize(movie)

      conn
      |> put_status(:ok)
      |> json(response_body)
    end
  end
end

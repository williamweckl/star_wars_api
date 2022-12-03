defmodule StarWars do
  @moduledoc """
  StarWars keeps the contexts that define your domain and business logic.

  Contexts are also responsible for exposing the use cases to other layers like delivery mechanisms (eg. Web API).

  Looking this module code should give the developer an overview of all the business use cases of the business context.
  """

  use CleanArchitecture.BoundedContext

  alias StarWars.Entities.MovieDirector

  # Movie Director

  @doc """
  Creates or updates a movie director.

  ## Examples
      iex> upsert_movie_director(%{field: "value"})
      {:ok, %MovieDirector{}}

      iex> upsert_movie_director(%{field: "bad_value"})
      {:error, %Ecto.Changeset{}}
  """
  def upsert_movie_director(%{} = input) do
    with {:ok, validated_input} <- Contracts.MovieDirector.Upsert.validate_input(input),
         {:ok, %MovieDirector{} = movie_director} <-
           Interactors.MovieDirector.Upsert.call(validated_input) do
      {:ok, movie_director}
    else
      {:error, %Changeset{} = changeset} ->
        {:error, changeset}
    end
  end
end

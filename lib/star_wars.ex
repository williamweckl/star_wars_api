defmodule StarWars do
  @moduledoc """
  StarWars keeps the contexts that define your domain and business logic.

  Contexts are also responsible for exposing the use cases to other layers like delivery mechanisms (eg. Web API).

  Looking this module code should give the developer an overview of all the business use cases of the business context.
  """

  use CleanArchitecture.BoundedContext

  alias StarWars.Entities.Climate
  alias StarWars.Entities.Movie
  alias StarWars.Entities.MovieDirector
  alias StarWars.Entities.Planet
  alias StarWars.Entities.Terrain

  # Climate

  @doc """
  Creates or updates a climate.

  ## Examples
      iex> upsert_climate(%{field: "value"})
      {:ok, %Climate{}}

      iex> upsert_climate(%{field: "bad_value"})
      {:error, %Ecto.Changeset{}}
  """
  def upsert_climate(%{} = input) do
    with {:ok, validated_input} <- Contracts.Climate.Upsert.validate_input(input),
         {:ok, %Climate{} = climate} <-
           Interactors.Climate.Upsert.call(validated_input) do
      {:ok, climate}
    else
      {:error, %Changeset{} = changeset} ->
        {:error, changeset}
    end
  end

  # Terrain

  @doc """
  Creates or updates a terrain.

  ## Examples
      iex> upsert_terrain(%{field: "value"})
      {:ok, %Terrain{}}

      iex> upsert_terrain(%{field: "bad_value"})
      {:error, %Ecto.Changeset{}}
  """
  def upsert_terrain(%{} = input) do
    with {:ok, validated_input} <- Contracts.Terrain.Upsert.validate_input(input),
         {:ok, %Terrain{} = terrain} <-
           Interactors.Terrain.Upsert.call(validated_input) do
      {:ok, terrain}
    else
      {:error, %Changeset{} = changeset} ->
        {:error, changeset}
    end
  end

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

  # Movie

  @doc """
  Creates or updates a movie director.

  ## Examples
      iex> upsert_movie(%{field: "value"})
      {:ok, %Movie{}}

      iex> upsert_movie(%{field: "bad_value"})
      {:error, %Ecto.Changeset{}}
  """
  def upsert_movie(%{} = input) do
    with {:ok, validated_input} <- Contracts.Movie.Upsert.validate_input(input),
         {:ok, %Movie{} = movie} <-
           Interactors.Movie.Upsert.call(validated_input) do
      {:ok, movie}
    else
      {:error, %Changeset{} = changeset} ->
        {:error, changeset}
    end
  end

  # Planet

  @doc """
  Creates or updates a planet.

  ## Examples
      iex> upsert_planet(%{field: "value"})
      {:ok, %Planet{}}

      iex> upsert_planet(%{field: "bad_value"})
      {:error, %Ecto.Changeset{}}
  """
  def upsert_planet(%{} = input) do
    with {:ok, validated_input} <- Contracts.Planet.Upsert.validate_input(input),
         {:ok, %Planet{} = planet} <-
           Interactors.Planet.Upsert.call(validated_input) do
      {:ok, planet}
    else
      {:error, %Changeset{} = changeset} ->
        {:error, changeset}
    end
  end
end

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
  Returns the list of planets.

  ## Examples
      iex> list_planets()
      %Pagination{
        entries: [], page_number: 1, page_size: 10, total_entries: 0, total_pages: 0
      }

      iex> list_planets(%{page: 2, page_size: 4})
      %Pagination{
        entries: [%Planet{}, ...], page_number: 2, page_size: 4, total_entries: 8, total_pages: 2
      }
  """
  def list_planets(input \\ %{}) do
    case Contracts.Planet.List.validate_input(input) do
      {:ok, validated_input} ->
        %Pagination{entries: _, page_number: _, page_size: _, total_entries: _, total_pages: _} =
          Interactors.Planet.List.call(validated_input)

      {:error, %Changeset{} = changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Gets a planet by id.
  Raises `Ecto.NoResultError` if the Planet does not exist.

  ## Examples
      iex> get_planet!(%{id: "679a45df-380c-4057-ac73-a0f1de5abb5b"}
      {:ok, %Planet{}}

      iex> get_planet!(%{id: "d5265c50-67ab-4a11-8d7e-8c2caa589634"}
      ** (Ecto.NoResultsError)

      iex> get_planet!(%{id: "invalid"}
      ** (Ecto.Query.CastError)
  """

  def get_planet!(input) do
    case Contracts.Planet.Get.validate_input(input) do
      {:ok, validated_input} ->
        %Planet{} = Interactors.Planet.Get.call(validated_input)

      {:error, %Changeset{} = changeset} ->
        {:error, changeset}
    end
  end

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

  @doc """
  Loads a planet and related data from the integration source.

  If the planet or the related records already exists, they will be updated.
  If the records does not exist yet, they will be created.

  After getting the data from the integration source, the hole persistence process is being made inside a transaction.
  This means that if some errors happens, no data is persisted.

  ## Examples
      iex> load_planet_from_integration(%{field: "value"})
      {:ok, %Planet{}}

      iex> load_planet_from_integration(%{field: "value"})
      {:error, :invalid_response}

      iex> load_planet_from_integration(%{field: "value"})
      {:error, %StarWars.HTTPClientResponse{status_code: 500, body: "", headers: []}}
  """
  def load_planet_from_integration(%{} = input) do
    with {:ok, validated_input} <- Contracts.Planet.LoadFromIntegration.validate_input(input),
         {:ok, %Planet{} = planet} <-
           Interactors.Planet.LoadFromIntegration.call(validated_input) do
      {:ok, planet}
    else
      {:error, %Changeset{} = changeset} ->
        {:error, changeset}

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Deletes a planet by filling deleted_at field.

  ## Examples
      iex> delete_planet(%{field: "value"})
      {:ok, %Planet{}}

      iex> delete_planet(%{field: "bad_value"})
      {:error, %Ecto.Changeset{}}
  """
  def delete_planet(%{} = input) do
    with {:ok, validated_input} <- Contracts.Planet.Delete.validate_input(input),
         {:ok, %Planet{} = planet} <-
           Interactors.Planet.Delete.call(validated_input) do
      {:ok, planet}
    else
      {:error, %Changeset{} = changeset} ->
        {:error, changeset}
    end
  end
end

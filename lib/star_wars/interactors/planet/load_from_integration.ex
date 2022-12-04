defmodule StarWars.Interactors.Planet.LoadFromIntegration do
  @moduledoc """
  Planet load from an integration use case.

  Do not call this module directly, use always the StarWars module that is the boundary context.

  It will request the API according to the integration source informed and persist the data to the database.
  """

  use CleanArchitecture.Interactor

  # Database transactions
  alias Ecto.Multi

  alias StarWars.Entities.Planet
  alias StarWars.Enums.IntegrationSource
  alias StarWars.Repo

  alias StarWars.IntegrationSource.ClimateResponse
  alias StarWars.IntegrationSource.MovieDirectorResponse
  alias StarWars.IntegrationSource.MovieResponse
  alias StarWars.IntegrationSource.PlanetResponse
  alias StarWars.IntegrationSource.TerrainResponse

  @doc """
  Loads a planet from an integration.
  """
  def call(%{integration_source: integration_source, integration_id: "" <> integration_id})
      when is_atom(integration_source) do
    adapter = IntegrationSource.get_adapter(integration_source)

    case adapter.get_planet(integration_id) do
      {:ok,
       %PlanetResponse{climates: climates, terrains: terrains, movies: movies} = planet_response} ->
        # Database transaction
        Multi.new()
        |> Multi.run(:climates, &upsert_climates(&1, &2, climates))
        |> Multi.run(:terrains, &upsert_terrains(&1, &2, terrains))
        |> Multi.run(:movie_directors, &upsert_movie_directors_from_movies(&1, &2, movies))
        |> Multi.run(:movies, &upsert_movies(&1, &2, movies))
        |> Multi.run(:planet, &upsert_planet(&1, &2, planet_response))
        |> Repo.transaction()
        |> handle_output()

      error_response ->
        error_response
    end
  end

  defp upsert_climates(_repo, _, climates) when is_list(climates) do
    climates = Enum.map(climates, &upsert_climate(&1))

    {:ok, climates}
  end

  defp upsert_climate(%ClimateResponse{id: id, name: name, integration_source: integration_source}) do
    {:ok, climate} =
      StarWars.upsert_climate(%{id: id, name: name, integration_source: integration_source})

    climate
  end

  defp upsert_terrains(_repo, _, terrains) when is_list(terrains) do
    terrains = Enum.map(terrains, &upsert_terrain(&1))

    {:ok, terrains}
  end

  defp upsert_terrain(%TerrainResponse{id: id, name: name, integration_source: integration_source}) do
    {:ok, terrain} =
      StarWars.upsert_terrain(%{id: id, name: name, integration_source: integration_source})

    terrain
  end

  defp upsert_movie_directors_from_movies(_repo, _, movies) when is_list(movies) do
    movie_directors = Enum.map(movies, &upsert_movie_director_from_movie(&1))

    {:ok, movie_directors}
  end

  defp upsert_movie_director_from_movie(%MovieResponse{
         director: %MovieDirectorResponse{name: name, integration_source: integration_source}
       }) do
    {:ok, movie_director} =
      StarWars.upsert_movie_director(%{name: name, integration_source: integration_source})

    movie_director
  end

  defp upsert_movies(_repo, %{movie_directors: movie_directors}, movies) when is_list(movies) do
    movies = Enum.map(movies, &upsert_movie(&1, movie_directors))

    {:ok, movies}
  end

  defp upsert_movie(
         %MovieResponse{
           title: title,
           release_date: release_date,
           integration_source: integration_source,
           integration_id: integration_id,
           director: %MovieDirectorResponse{name: director_name}
         },
         movie_directors
       )
       when is_list(movie_directors) do
    director = get_movie_director_by_name_from_list(movie_directors, director_name)

    {:ok, movie} =
      StarWars.upsert_movie(%{
        title: title,
        release_date: release_date,
        integration_source: integration_source,
        integration_id: integration_id,
        director_id: director.id
      })

    movie
  end

  defp get_movie_director_by_name_from_list(movie_directors, "" <> director_name)
       when is_list(movie_directors) do
    Enum.find(movie_directors, fn movie_director ->
      movie_director.name == director_name
    end)
  end

  defp upsert_planet(
         _repo,
         %{
           climates: climates,
           terrains: terrains,
           movies: movies
         },
         %PlanetResponse{
           name: "" <> name,
           integration_source: integration_source,
           integration_id: "" <> integration_id
         }
       ) do
    StarWars.upsert_planet(%{
      name: name,
      integration_source: integration_source,
      integration_id: integration_id,
      climates: climates,
      terrains: terrains,
      movies: movies
    })
  end

  defp handle_output({:ok, %{planet: %Planet{} = planet}}), do: {:ok, planet}
end

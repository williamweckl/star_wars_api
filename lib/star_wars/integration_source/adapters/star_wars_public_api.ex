defmodule StarWars.IntegrationSource.Adapters.StarWarsPublicAPI do
  @moduledoc """
  Star Wars public API intregration source adapter that triggers HTTP requests to Star Wars public API endpoints.
  """

  require Logger

  alias StarWars.HTTPClient
  alias StarWars.HTTPClientResponse

  alias StarWars.ErrorsHandler

  alias StarWars.IntegrationSource.ClimateResponse
  alias StarWars.IntegrationSource.MovieDirectorResponse
  alias StarWars.IntegrationSource.MovieResponse
  alias StarWars.IntegrationSource.PlanetResponse
  alias StarWars.IntegrationSource.TerrainResponse

  @base_url "https://swapi.py4e.com"
  @endpoints %{
    planet: "api/planets/:id/",
    planets: "api/planets/",
    movie: "api/films/:id/"
  }

  @doc """
  Returns the base URL of the Star Wars Public API.

  ## Examples
      iex> StarWars.IntegrationSource.Adapters.StarWarsPublicAPI.base_url()
      "https://swapi.py4e.com"
  """
  def base_url, do: @base_url

  @doc """
  Returns the URL of the planet endpoint by its ID.

  ## Examples
      iex> StarWars.IntegrationSource.Adapters.StarWarsPublicAPI.planet_url(1)
      "https://swapi.py4e.com/api/planets/1/"

      iex> StarWars.IntegrationSource.Adapters.StarWarsPublicAPI.planet_url(123)
      "https://swapi.py4e.com/api/planets/123/"

      iex> StarWars.IntegrationSource.Adapters.StarWarsPublicAPI.planet_url("xpto")
      "https://swapi.py4e.com/api/planets/xpto/"
  """
  def planet_url("" <> id) do
    "#{base_url()}/#{@endpoints[:planet]}" |> String.replace(":id", "#{id}")
  end

  @doc """
  Returns the URL of the movie endpoint by its ID.

  ## Examples
      iex> StarWars.IntegrationSource.Adapters.StarWarsPublicAPI.movie_url(1)
      "https://swapi.py4e.com/api/films/1/"

      iex> StarWars.IntegrationSource.Adapters.StarWarsPublicAPI.movie_url(123)
      "https://swapi.py4e.com/api/films/123/"

      iex> StarWars.IntegrationSource.Adapters.StarWarsPublicAPI.movie_url("xpto")
      "https://swapi.py4e.com/api/films/xpto/"
  """
  def movie_url("" <> id) do
    "#{base_url()}/#{@endpoints[:movie]}" |> String.replace(":id", "#{id}")
  end

  @doc """
  Triggers an HTTP request to Star Wars public API planet endpoint.

  Returns a planet response when request is successful, if it is not, returns an error.

  ## Examples
      iex> StarWars.IntegrationSource.Adapters.Mock.get_planet("not_found")
      {:error, %StarWars.HTTPClientResponse{status_code: 404, body: "", headers: []}}

      iex> StarWars.IntegrationSource.Adapters.Mock.get_planet("error")
      {:error, %StarWars.HTTPClientResponse{status_code: 500, body: "", headers: []}}

      iex> StarWars.IntegrationSource.Adapters.Mock.get_planet("not_json")
      {:error, :invalid_response}

      iex> StarWars.IntegrationSource.Adapters.Mock.get_planet("unhandled_response")
      {:error, :unhandled_response}

      iex> StarWars.IntegrationSource.Adapters.Mock.get_planet("1")
      {:ok, %StarWars.IntegrationSource.PlanetResponse{
        name: "Tattoine",
        integration_source: "star_wars_public_api",
        integration_id: "1",
        climates: [
          %StarWars.IntegrationSource.ClimateResponse{
            id: "arid",
            name: "Arid",
            integration_source: "star_wars_public_api"
          }
        ],
        terrains: [
          %StarWars.IntegrationSource.TerrainResponse{
            id: "ocean",
            name: "Ocean",
            integration_source: "star_wars_public_api"
          }
        ],
        movies: [
          %StarWars.IntegrationSource.MovieResponse{
            title: "A New Hope",
            release_date: ~D[2000-01-01],
            integration_source: "star_wars_public_api",
            integration_id: "1",
            director: %StarWars.IntegrationSource.MovieDirectorResponse{
              name: "George Lucas",
              integration_source: "star_wars_public_api"
            }
          }
        ]
      }}
  """
  def get_planet("" <> id) do
    url = planet_url(id)

    case HTTPClient.get(url, %{format: "json"}) do
      {:ok, %HTTPClientResponse{body: body}} ->
        case Jason.decode(body) do
          {:ok, json_body} ->
            Logger.log(:info, "Get planet request was successful. #{inspect(json_body)}",
              module: __MODULE__,
              function_name: :get_planet
            )

            parse_planet_response(json_body)

          _ ->
            report_json_decode_error(:get_planet, body)
            {:error, :invalid_response}
        end

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Triggers an HTTP request to Star Wars public API movie endpoint.

  Returns a movie response when request is successful, if it is not, returns an error.

  ## Examples
      iex> StarWars.IntegrationSource.Adapters.Mock.get_movie("not_found")
      {:error, %StarWars.HTTPClientResponse{status_code: 404, body: "", headers: []}}

      iex> StarWars.IntegrationSource.Adapters.Mock.get_movie("error")
      {:error, %StarWars.HTTPClientResponse{status_code: 500, body: "", headers: []}}

      iex> StarWars.IntegrationSource.Adapters.Mock.get_movie("not_json")
      {:error, :invalid_response}

      iex> StarWars.IntegrationSource.Adapters.Mock.get_movie("unhandled_response")
      {:error, :unhandled_response}

      iex> StarWars.IntegrationSource.Adapters.Mock.get_movie("1")
      {:ok, %StarWars.IntegrationSource.MovieResponse{
        title: "1",
        release_date: ~D[2000-01-01],
        integration_source: "star_wars_public_api",
        integration_id: "1",
        director: %StarWars.IntegrationSource.MovieDirectorResponse{
          name: "George Lucas",
          integration_source: "star_wars_public_api"
        }
      }}
  """
  def get_movie("" <> id) do
    url = movie_url(id)

    case HTTPClient.get(url, %{format: "json"}) do
      {:ok, %HTTPClientResponse{body: body}} ->
        case Jason.decode(body) do
          {:ok, json_body} ->
            Logger.log(:info, "Get movie request was successful. #{inspect(json_body)}",
              module: __MODULE__,
              function_name: :get_movie
            )

            parse_movie_response(json_body)

          _ ->
            report_json_decode_error(:get_movie, body)
            {:error, :invalid_response}
        end

      {:error, error} ->
        {:error, error}
    end
  end

  defp parse_planet_response(%{
         "name" => "" <> name,
         "climate" => "" <> climates,
         "terrain" => "" <> terrains,
         "films" => movies_urls,
         "url" => "" <> planet_url
       })
       when is_list(movies_urls) do
    integration_id = parse_integration_id(planet_url, "planets")
    climates = parse_climates_string(climates)
    terrains = parse_terrains_string(terrains)

    movies =
      movies_urls
      |> Enum.map(fn movie_url ->
        movie_url
        |> parse_integration_id("films")
        |> get_movie()
      end)

    movie_error_response =
      Enum.find(movies, fn movie ->
        case movie do
          {:ok, _movie} -> nil
          error_response -> error_response
        end
      end)

    if movie_error_response do
      movie_error_response
    else
      movies =
        Enum.map(movies, fn {:ok, movie} ->
          movie
        end)

      planet_response = %PlanetResponse{
        name: name,
        integration_source: :star_wars_public_api,
        integration_id: integration_id,
        climates: climates,
        terrains: terrains,
        movies: movies
      }

      {:ok, planet_response}
    end
  end

  defp parse_planet_response(response) do
    report_parse_error(:parse_planet_response, response)
    {:error, :api_response_changed}
  end

  defp parse_climates_string("" <> climates) do
    climates
    |> String.replace(" ", "")
    |> String.split(",")
    |> Enum.filter(fn climate_name ->
      climate_name != ""
    end)
    |> Enum.map(fn climate_name ->
      id = climate_name |> String.replace(" ", "_") |> String.downcase()
      name = climate_name |> String.capitalize()

      %ClimateResponse{id: id, name: name, integration_source: :star_wars_public_api}
    end)
  end

  defp parse_terrains_string("" <> terrains) do
    terrains
    |> String.replace(" ", "")
    |> String.split(",")
    |> Enum.filter(fn terrain_name ->
      terrain_name != ""
    end)
    |> Enum.map(fn terrain_name ->
      id = terrain_name |> String.replace(" ", "_") |> String.downcase()
      name = terrain_name |> String.capitalize()

      %TerrainResponse{id: id, name: name, integration_source: :star_wars_public_api}
    end)
  end

  defp parse_movie_response(
         %{
           "title" => "" <> title,
           "release_date" => "" <> release_date,
           "url" => "" <> movie_url,
           "director" => "" <> movie_director
         } = response
       ) do
    integration_id = parse_integration_id(movie_url, "films")
    release_date = Date.from_iso8601!(release_date)
    director = parse_movie_director_response(movie_director)

    movie_response = %MovieResponse{
      title: title,
      release_date: release_date,
      integration_source: :star_wars_public_api,
      integration_id: integration_id,
      director: director
    }

    {:ok, movie_response}
  rescue
    ArgumentError ->
      report_parse_error(:parse_movie_response, response)
      {:error, :api_response_changed}
  end

  defp parse_movie_response(response) do
    report_parse_error(:parse_movie_response, response)

    {:error, :api_response_changed}
  end

  defp parse_movie_director_response(movie_director) do
    director_name = movie_director |> String.trim()

    %MovieDirectorResponse{
      name: director_name,
      integration_source: :star_wars_public_api
    }
  end

  defp parse_integration_id("" <> url, "" <> endpoint_namespace) do
    url
    |> String.replace("#{base_url()}/api/#{endpoint_namespace}/", "")
    |> String.replace("/", "")
  end

  defp report_json_decode_error(function_name, body) do
    {:current_stacktrace, stacktrace} = Process.info(self(), :current_stacktrace)

    ErrorsHandler.report_error(
      __MODULE__,
      function_name,
      "Failed to decode json response. #{inspect(body)}",
      stacktrace
    )
  end

  defp report_parse_error(function_name, response) do
    {:current_stacktrace, stacktrace} = Process.info(self(), :current_stacktrace)

    ErrorsHandler.report_error(
      __MODULE__,
      function_name,
      "Looks like the API response has been changed and the contract was broken! #{inspect(response)}",
      stacktrace
    )
  end
end

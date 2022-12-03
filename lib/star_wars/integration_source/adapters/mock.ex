defmodule StarWars.IntegrationSource.Adapters.Mock do
  @moduledoc """
  Mocked integration source adapter to prevent real HTTP requests being triggered by tests.
  """

  @base_url "https://webhook.site"
  @endpoints %{
    planet: "api/planets/:id/",
    planets: "api/planets/",
    movie: "api/films/:id/"
  }

  alias StarWars.IntegrationSource.ClimateResponse
  alias StarWars.IntegrationSource.MovieDirectorResponse
  alias StarWars.IntegrationSource.MovieResponse
  alias StarWars.IntegrationSource.PlanetResponse
  alias StarWars.IntegrationSource.TerrainResponse

  alias StarWars.HTTPClientResponse

  @doc """
  Returns the base URL of the Mock adapter.

  ## Examples
      iex> StarWars.IntegrationSource.Adapters.Mock.base_url()
      "https://webhook.site"
  """
  def base_url, do: @base_url

  @doc """
  Returns the URL of the planet endpoint by its ID.

  ## Examples
      iex> StarWars.IntegrationSource.Adapters.Mock.planet_url("1")
      "https://webhook.site/api/planets/1/"

      iex> StarWars.IntegrationSource.Adapters.Mock.planet_url("123")
      "https://webhook.site/api/planets/123/"

      iex> StarWars.IntegrationSource.Adapters.Mock.planet_url("xpto")
      "https://webhook.site/api/planets/xpto/"
  """
  def planet_url("" <> id) do
    "#{base_url()}/#{@endpoints[:planet]}" |> String.replace(":id", "#{id}")
  end

  @doc """
  Returns the URL of the movie endpoint by its ID.

  ## Examples
      iex> StarWars.IntegrationSource.Adapters.Mock.movie_url("1")
      "https://webhook.site/api/films/1/"

      iex> StarWars.IntegrationSource.Adapters.Mock.movie_url("123")
      "https://webhook.site/api/films/123/"

      iex> StarWars.IntegrationSource.Adapters.Mock.movie_url("xpto")
      "https://webhook.site/api/films/xpto/"
  """
  def movie_url("" <> id) do
    "#{base_url()}/#{@endpoints[:movie]}" |> String.replace(":id", "#{id}")
  end

  @doc """
  Returns a mocked planet response when is successful, if it is not, returns an error.

  ## Examples
      iex> StarWars.IntegrationSource.Adapters.Mock.get_planet("not_found")
      {:error, %StarWars.HTTPClientResponse{status_code: 404, body: "", headers: []}}

      iex> StarWars.IntegrationSource.Adapters.Mock.get_planet("error")
      {:error, %StarWars.HTTPClientResponse{status_code: 500, body: "", headers: []}}

      iex> StarWars.IntegrationSource.Adapters.Mock.get_planet("not_json")
      {:error, :invalid_response}

      iex> StarWars.IntegrationSource.Adapters.Mock.get_planet("unhandled_response")
      {:error, :unhandled_response}

      iex> StarWars.IntegrationSource.Adapters.Mock.get_planet("Tattoine")
      {:ok, %StarWars.IntegrationSource.PlanetResponse{
        name: "Tattoine",
        integration_source: "star_wars_public_api",
        integration_id: "tattoine",
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
  def get_planet("not_found") do
    {:error, %HTTPClientResponse{status_code: 404, body: "", headers: []}}
  end

  def get_planet("error") do
    {:error, %HTTPClientResponse{status_code: 500, body: "", headers: []}}
  end

  def get_planet("not_json") do
    {:error, :invalid_response}
  end

  def get_planet("unhandled_response") do
    {:error, :unhandled_response}
  end

  def get_planet("" <> id) do
    response = %PlanetResponse{
      name: String.capitalize(id),
      integration_source: "star_wars_public_api",
      integration_id: String.downcase(id),
      climates: [
        %ClimateResponse{
          id: "arid",
          name: "Arid",
          integration_source: "star_wars_public_api"
        }
      ],
      terrains: [
        %TerrainResponse{
          id: "ocean",
          name: "Ocean",
          integration_source: "star_wars_public_api"
        }
      ],
      movies: [
        %MovieResponse{
          title: "A New Hope",
          release_date: ~D[2000-01-01],
          integration_source: "star_wars_public_api",
          integration_id: "1",
          director: %MovieDirectorResponse{
            name: "George Lucas",
            integration_source: "star_wars_public_api"
          }
        }
      ]
    }

    {:ok, response}
  end

  @doc """
  Returns a mocked movie response when is successful, if it is not, returns an error.

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
  def get_movie("not_found") do
    {:error, %HTTPClientResponse{status_code: 404, body: "", headers: []}}
  end

  def get_movie("error") do
    {:error, %HTTPClientResponse{status_code: 500, body: "", headers: []}}
  end

  def get_movie("not_json") do
    {:error, :invalid_response}
  end

  def get_movie("unhandled_response") do
    {:error, :unhandled_response}
  end

  def get_movie("" <> id) do
    response = %MovieResponse{
      title: String.capitalize(id),
      release_date: ~D[2000-01-01],
      integration_source: "star_wars_public_api",
      integration_id: id,
      director: %MovieDirectorResponse{
        name: "George Lucas",
        integration_source: "star_wars_public_api"
      }
    }

    {:ok, response}
  end
end

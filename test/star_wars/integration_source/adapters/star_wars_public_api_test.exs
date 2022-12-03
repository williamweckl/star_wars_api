defmodule StarWars.IntegrationSource.Adapters.StarWarsPublicAPITest do
  use StarWars.DataCase

  import ExUnit.CaptureLog
  import Mock

  alias StarWars.IntegrationSource.Adapters.StarWarsPublicAPI

  alias StarWars.HTTPClient
  alias StarWars.HTTPClientResponse

  describe "base_url/0" do
    test "returns star wars public API base URL" do
      assert "https://swapi.py4e.com" == StarWarsPublicAPI.base_url()
    end
  end

  describe "planet_url/1" do
    test "returns star wars public API planet URL according to id informed" do
      assert "https://swapi.py4e.com/api/planets/1/" == StarWarsPublicAPI.planet_url("1")
      assert "https://swapi.py4e.com/api/planets/123/" == StarWarsPublicAPI.planet_url("123")
      assert "https://swapi.py4e.com/api/planets/xpto/" == StarWarsPublicAPI.planet_url("xpto")
    end
  end

  describe "movie_url/1" do
    test "returns star wars public API planet URL according to id informed" do
      assert "https://swapi.py4e.com/api/films/1/" == StarWarsPublicAPI.movie_url("1")
      assert "https://swapi.py4e.com/api/films/123/" == StarWarsPublicAPI.movie_url("123")
      assert "https://swapi.py4e.com/api/films/xpto/" == StarWarsPublicAPI.movie_url("xpto")
    end
  end

  describe "get_planet/1" do
    test "returns error when planet was not found" do
      error_response = {:error, %HTTPClientResponse{status_code: 404, body: "", headers: []}}

      with_mock(
        HTTPClient,
        get: fn _url, _params ->
          error_response
        end
      ) do
        assert error_response == StarWarsPublicAPI.get_planet("123")

        assert_called_exactly(
          HTTPClient.get(StarWarsPublicAPI.planet_url("123"), %{format: "json"}),
          1
        )
      end
    end

    test "returns error when planet request returns error" do
      error_response = {:error, %HTTPClientResponse{status_code: 500, body: "", headers: []}}

      with_mock(
        HTTPClient,
        get: fn _url, _params ->
          error_response
        end
      ) do
        assert error_response == StarWarsPublicAPI.get_planet("123")

        assert_called_exactly(
          HTTPClient.get(StarWarsPublicAPI.planet_url("123"), %{format: "json"}),
          1
        )
      end
    end

    test "returns error when planet request returns ok but with content not json" do
      response = {:ok, %HTTPClientResponse{status_code: 200, body: "not json", headers: []}}

      with_mock(
        HTTPClient,
        get: fn _url, _params ->
          response
        end
      ) do
        assert capture_log(fn ->
                 assert {:error, :invalid_response} == StarWarsPublicAPI.get_planet("123")
               end) =~ "Failed to decode json response. #{inspect("not json")}"

        assert_called_exactly(
          HTTPClient.get(StarWarsPublicAPI.planet_url("123"), %{format: "json"}),
          1
        )
      end
    end

    test "returns error when planet request returns unhandled_response" do
      error_response = {:error, :unhandled_response}

      with_mock(
        HTTPClient,
        get: fn _url, _params ->
          error_response
        end
      ) do
        assert error_response == StarWarsPublicAPI.get_planet("123")

        assert_called_exactly(
          HTTPClient.get(StarWarsPublicAPI.planet_url("123"), %{format: "json"}),
          1
        )
      end
    end

    test "returns and logs error when the response is a valid json but the API for some reason changed the field names of the response" do
      body = %{
        "another_climate_name" => "arid",
        "created" => "2014-12-09T13:50:49.641000Z",
        "diameter" => "10465",
        "edited" => "2014-12-20T20:58:18.411000Z",
        "another_films_name" => [
          "https://swapi.py4e.com/api/films/1/",
          "https://swapi.py4e.com/api/films/3/",
          "https://swapi.py4e.com/api/films/4/",
          "https://swapi.py4e.com/api/films/5/",
          "https://swapi.py4e.com/api/films/6/"
        ],
        "gravity" => "1 standard",
        "another_name" => "Tatooine",
        "another_terrain_name" => "desert",
        "another_url" => "https://swapi.py4e.com/api/planets/1/"
      }

      json_body = Jason.encode!(body)
      response = {:ok, %HTTPClientResponse{body: json_body}}

      with_mock(
        HTTPClient,
        get: fn _url, _params ->
          response
        end
      ) do
        assert capture_log(fn ->
                 assert {:error, :api_response_changed} == StarWarsPublicAPI.get_planet("123")
               end) =~ inspect(body)

        assert_called_exactly(
          HTTPClient.get(StarWarsPublicAPI.planet_url("123"), %{format: "json"}),
          1
        )
      end
    end

    test "returns and logs error when the response is a valid json but the API for some reason changed the format of the response" do
      body = %{
        "climate" => ["arid"],
        "films" => [%{"id" => 1, "name" => "A New Hope"}],
        "name" => "Tatooine",
        "terrain" => ["desert"],
        "url" => ["https://swapi.py4e.com/api/planets/1/"]
      }

      json_body = Jason.encode!(body)
      response = {:ok, %HTTPClientResponse{body: json_body}}

      with_mock(
        HTTPClient,
        get: fn _url, _params ->
          response
        end
      ) do
        assert capture_log(fn ->
                 assert {:error, :api_response_changed} == StarWarsPublicAPI.get_planet("123")
               end) =~ inspect(body)

        assert_called_exactly(
          HTTPClient.get(StarWarsPublicAPI.planet_url("123"), %{format: "json"}),
          1
        )
      end
    end

    test "returns error when planet response is success but movie was not found" do
      planet_body = %{
        "climate" => "arid",
        "films" => [
          "https://swapi.py4e.com/api/films/1/",
          "https://swapi.py4e.com/api/films/3/",
          "https://swapi.py4e.com/api/films/4/",
          "https://swapi.py4e.com/api/films/5/",
          "https://swapi.py4e.com/api/films/6/"
        ],
        "name" => "Tatooine",
        "terrain" => "desert",
        "url" => "https://swapi.py4e.com/api/planets/1/"
      }

      json_planet_body = Jason.encode!(planet_body)

      error_response = {:error, %HTTPClientResponse{status_code: 404, body: "", headers: []}}

      with_mock(
        HTTPClient,
        get: fn url, _params ->
          if url == "https://swapi.py4e.com/api/planets/1/" do
            {:ok, %HTTPClientResponse{body: json_planet_body}}
          else
            error_response
          end
        end
      ) do
        assert error_response == StarWarsPublicAPI.get_planet("1")

        assert_called_exactly(
          HTTPClient.get(StarWarsPublicAPI.planet_url("1"), %{format: "json"}),
          1
        )

        assert_called_exactly(
          HTTPClient.get(StarWarsPublicAPI.movie_url("1"), %{format: "json"}),
          1
        )
      end
    end

    test "returns error when planet response is success but movie request returns error" do
      planet_body = %{
        "climate" => "arid",
        "films" => [
          "https://swapi.py4e.com/api/films/1/",
          "https://swapi.py4e.com/api/films/3/",
          "https://swapi.py4e.com/api/films/4/",
          "https://swapi.py4e.com/api/films/5/",
          "https://swapi.py4e.com/api/films/6/"
        ],
        "name" => "Tatooine",
        "terrain" => "desert",
        "url" => "https://swapi.py4e.com/api/planets/1/"
      }

      json_planet_body = Jason.encode!(planet_body)

      error_response = {:error, %HTTPClientResponse{status_code: 500, body: "", headers: []}}

      with_mock(
        HTTPClient,
        get: fn url, _params ->
          if url == "https://swapi.py4e.com/api/planets/1/" do
            {:ok, %HTTPClientResponse{body: json_planet_body}}
          else
            error_response
          end
        end
      ) do
        assert error_response == StarWarsPublicAPI.get_planet("1")

        assert_called_exactly(
          HTTPClient.get(StarWarsPublicAPI.planet_url("1"), %{format: "json"}),
          1
        )

        assert_called_exactly(
          HTTPClient.get(StarWarsPublicAPI.movie_url("1"), %{format: "json"}),
          1
        )
      end
    end

    test "returns error when planet response is success but movie request returns not json content" do
      planet_body = %{
        "climate" => "arid",
        "films" => [
          "https://swapi.py4e.com/api/films/1/",
          "https://swapi.py4e.com/api/films/3/",
          "https://swapi.py4e.com/api/films/4/",
          "https://swapi.py4e.com/api/films/5/",
          "https://swapi.py4e.com/api/films/6/"
        ],
        "name" => "Tatooine",
        "terrain" => "desert",
        "url" => "https://swapi.py4e.com/api/planets/1/"
      }

      json_planet_body = Jason.encode!(planet_body)

      response = {:ok, %HTTPClientResponse{status_code: 200, body: "not json", headers: []}}

      with_mock(
        HTTPClient,
        get: fn url, _params ->
          if url == "https://swapi.py4e.com/api/planets/1/" do
            {:ok, %HTTPClientResponse{body: json_planet_body}}
          else
            response
          end
        end
      ) do
        assert capture_log(fn ->
                 assert {:error, :invalid_response} == StarWarsPublicAPI.get_planet("1")
               end) =~ "Failed to decode json response. #{inspect("not json")}"

        assert_called_exactly(
          HTTPClient.get(StarWarsPublicAPI.planet_url("1"), %{format: "json"}),
          1
        )

        assert_called_exactly(
          HTTPClient.get(StarWarsPublicAPI.movie_url("1"), %{format: "json"}),
          1
        )
      end
    end

    test "returns error when planet response is success but movie request returns unhandled_response" do
      planet_body = %{
        "climate" => "arid",
        "films" => [
          "https://swapi.py4e.com/api/films/1/",
          "https://swapi.py4e.com/api/films/3/",
          "https://swapi.py4e.com/api/films/4/",
          "https://swapi.py4e.com/api/films/5/",
          "https://swapi.py4e.com/api/films/6/"
        ],
        "name" => "Tatooine",
        "terrain" => "desert",
        "url" => "https://swapi.py4e.com/api/planets/1/"
      }

      json_planet_body = Jason.encode!(planet_body)

      error_response = {:error, :unhandled_response}

      with_mock(
        HTTPClient,
        get: fn url, _params ->
          if url == "https://swapi.py4e.com/api/planets/1/" do
            {:ok, %HTTPClientResponse{body: json_planet_body}}
          else
            error_response
          end
        end
      ) do
        assert error_response == StarWarsPublicAPI.get_planet("1")

        assert_called_exactly(
          HTTPClient.get(StarWarsPublicAPI.planet_url("1"), %{format: "json"}),
          1
        )

        assert_called_exactly(
          HTTPClient.get(StarWarsPublicAPI.movie_url("1"), %{format: "json"}),
          1
        )
      end
    end

    test "returns error when planet response is success but movie request returns json with not expected format" do
      planet_body = %{
        "climate" => "arid",
        "films" => [
          "https://swapi.py4e.com/api/films/1/",
          "https://swapi.py4e.com/api/films/3/",
          "https://swapi.py4e.com/api/films/4/",
          "https://swapi.py4e.com/api/films/5/",
          "https://swapi.py4e.com/api/films/6/"
        ],
        "name" => "Tatooine",
        "terrain" => "desert",
        "url" => "https://swapi.py4e.com/api/planets/1/"
      }

      json_planet_body = Jason.encode!(planet_body)

      movie_body = %{
        "aother_director_name" => "George Lucas",
        "aother_release_date_name" => "2002-05-16",
        "aother_title_name" => "Attack of the Clones",
        "aother_url_name" => "https://swapi.py4e.com/api/films/1/"
      }

      with_mock(
        HTTPClient,
        get: fn url, _params ->
          if url == "https://swapi.py4e.com/api/planets/1/" do
            {:ok, %HTTPClientResponse{body: json_planet_body}}
          else
            json_body = Jason.encode!(movie_body)
            {:ok, %HTTPClientResponse{body: json_body}}
          end
        end
      ) do
        assert capture_log(fn ->
                 assert {:error, :api_response_changed} == StarWarsPublicAPI.get_planet("1")
               end) =~ inspect(movie_body)

        assert_called_exactly(
          HTTPClient.get(StarWarsPublicAPI.planet_url("1"), %{format: "json"}),
          1
        )

        assert_called_exactly(
          HTTPClient.get(StarWarsPublicAPI.movie_url("1"), %{format: "json"}),
          1
        )
      end
    end

    test "returns planet response when is successful" do
      body = %{
        "climate" => "arid",
        "created" => "2014-12-09T13:50:49.641000Z",
        "diameter" => "10465",
        "edited" => "2014-12-20T20:58:18.411000Z",
        "films" => ["https://swapi.py4e.com/api/films/1/"],
        "gravity" => "1 standard",
        "name" => "Tatooine",
        "orbital_period" => "304",
        "population" => "200000",
        "residents" => [
          "https://swapi.py4e.com/api/people/1/",
          "https://swapi.py4e.com/api/people/2/",
          "https://swapi.py4e.com/api/people/4/",
          "https://swapi.py4e.com/api/people/6/",
          "https://swapi.py4e.com/api/people/7/",
          "https://swapi.py4e.com/api/people/8/",
          "https://swapi.py4e.com/api/people/9/",
          "https://swapi.py4e.com/api/people/11/",
          "https://swapi.py4e.com/api/people/43/",
          "https://swapi.py4e.com/api/people/62/"
        ],
        "rotation_period" => "23",
        "surface_water" => "1",
        "terrain" => "desert",
        "url" => "https://swapi.py4e.com/api/planets/1/"
      }

      json_body = Jason.encode!(body)
      response = {:ok, %HTTPClientResponse{body: json_body}}

      with_mock(
        HTTPClient,
        get: fn url, _params ->
          if url == "https://swapi.py4e.com/api/planets/1/" do
            response
          else
            movie_body = %{
              "director" => "  George Lucas   ",
              "release_date" => "2002-05-16",
              "title" => "Attack of the Clones",
              "url" => "https://swapi.py4e.com/api/films/1/"
            }

            json_body = Jason.encode!(movie_body)
            {:ok, %HTTPClientResponse{body: json_body}}
          end
        end
      ) do
        assert {:ok,
                %StarWars.IntegrationSource.PlanetResponse{
                  name: "Tatooine",
                  integration_source: :star_wars_public_api,
                  integration_id: "1",
                  climates: [
                    %StarWars.IntegrationSource.ClimateResponse{
                      id: "arid",
                      name: "Arid",
                      integration_source: :star_wars_public_api
                    }
                  ],
                  movies: [
                    %StarWars.IntegrationSource.MovieResponse{
                      title: "Attack of the Clones",
                      release_date: ~D[2002-05-16],
                      integration_source: :star_wars_public_api,
                      integration_id: "1",
                      director: %StarWars.IntegrationSource.MovieDirectorResponse{
                        name: "George Lucas",
                        integration_source: :star_wars_public_api
                      }
                    }
                  ],
                  terrains: [
                    %StarWars.IntegrationSource.TerrainResponse{
                      id: "desert",
                      name: "Desert",
                      integration_source: :star_wars_public_api
                    }
                  ]
                }} == StarWarsPublicAPI.get_planet("1")

        assert_called_exactly(
          HTTPClient.get(StarWarsPublicAPI.planet_url("1"), %{format: "json"}),
          1
        )
      end
    end

    test "returns planet response when is successful but climates, movies and terrains are empty" do
      body = %{
        "climate" => "",
        "films" => [],
        "gravity" => "1 standard",
        "name" => "Tatooine",
        "rotation_period" => "23",
        "terrain" => "",
        "url" => "https://swapi.py4e.com/api/planets/1/"
      }

      json_body = Jason.encode!(body)
      response = {:ok, %HTTPClientResponse{body: json_body}}

      with_mock(
        HTTPClient,
        get: fn url, _params ->
          if url == "https://swapi.py4e.com/api/planets/1/" do
            response
          else
            movie_body = %{
              "director" => "  George Lucas   ",
              "release_date" => "2002-05-16",
              "title" => "Attack of the Clones",
              "url" => "https://swapi.py4e.com/api/films/1/"
            }

            json_body = Jason.encode!(movie_body)
            {:ok, %HTTPClientResponse{body: json_body}}
          end
        end
      ) do
        assert {:ok,
                %StarWars.IntegrationSource.PlanetResponse{
                  name: "Tatooine",
                  integration_source: :star_wars_public_api,
                  integration_id: "1",
                  climates: [],
                  movies: [],
                  terrains: []
                }} == StarWarsPublicAPI.get_planet("1")

        assert_called_exactly(
          HTTPClient.get(StarWarsPublicAPI.planet_url("1"), %{format: "json"}),
          1
        )
      end
    end
  end

  describe "get_movie/1" do
    test "returns error when movie was not found" do
      error_response = {:error, %HTTPClientResponse{status_code: 404, body: "", headers: []}}

      with_mock(
        HTTPClient,
        get: fn _url, _params ->
          error_response
        end
      ) do
        assert error_response == StarWarsPublicAPI.get_movie("123")

        assert_called_exactly(
          HTTPClient.get(StarWarsPublicAPI.movie_url("123"), %{format: "json"}),
          1
        )
      end
    end

    test "returns error when movie request returns error" do
      error_response = {:error, %HTTPClientResponse{status_code: 500, body: "", headers: []}}

      with_mock(
        HTTPClient,
        get: fn _url, _params ->
          error_response
        end
      ) do
        assert error_response == StarWarsPublicAPI.get_movie("123")

        assert_called_exactly(
          HTTPClient.get(StarWarsPublicAPI.movie_url("123"), %{format: "json"}),
          1
        )
      end
    end

    test "returns error and logs when movie request returns ok but with content not json" do
      response = {:ok, %HTTPClientResponse{status_code: 200, body: "not json", headers: []}}

      with_mock(
        HTTPClient,
        get: fn _url, _params ->
          response
        end
      ) do
        assert capture_log(fn ->
                 assert {:error, :invalid_response} == StarWarsPublicAPI.get_movie("123")
               end) =~ "Failed to decode json response. #{inspect("not json")}"

        assert_called_exactly(
          HTTPClient.get(StarWarsPublicAPI.movie_url("123"), %{format: "json"}),
          1
        )
      end
    end

    test "returns error when movie request returns unhandled_response" do
      error_response = {:error, :unhandled_response}

      with_mock(
        HTTPClient,
        get: fn _url, _params ->
          error_response
        end
      ) do
        assert error_response == StarWarsPublicAPI.get_movie("123")

        assert_called_exactly(
          HTTPClient.get(StarWarsPublicAPI.movie_url("123"), %{format: "json"}),
          1
        )
      end
    end

    test "returns and logs error when the response is a valid json but the API for some reason changed the field names of the response" do
      body = %{
        "aother_director_name" => "George Lucas",
        "aother_release_date_name" => "2002-05-16",
        "aother_title_name" => "Attack of the Clones",
        "aother_url_name" => "https://swapi.py4e.com/api/films/5/"
      }

      json_body = Jason.encode!(body)
      response = {:ok, %HTTPClientResponse{body: json_body}}

      with_mock(
        HTTPClient,
        get: fn _url, _params ->
          response
        end
      ) do
        assert capture_log(fn ->
                 assert {:error, :api_response_changed} == StarWarsPublicAPI.get_movie("123")
               end) =~ inspect(body)

        assert_called_exactly(
          HTTPClient.get(StarWarsPublicAPI.movie_url("123"), %{format: "json"}),
          1
        )
      end
    end

    test "returns and logs error when the response is a valid json but the API for some reason changed the format of the response" do
      body = %{
        "director" => %{"id" => "1", "name" => "George Lucas"},
        "release_date" => ["2002-05-16"],
        "title" => 123,
        "url" => ["https://swapi.py4e.com/api/films/5/"]
      }

      json_body = Jason.encode!(body)
      response = {:ok, %HTTPClientResponse{body: json_body}}

      with_mock(
        HTTPClient,
        get: fn _url, _params ->
          response
        end
      ) do
        assert capture_log(fn ->
                 assert {:error, :api_response_changed} == StarWarsPublicAPI.get_movie("123")
               end) =~ inspect(body)

        assert_called_exactly(
          HTTPClient.get(StarWarsPublicAPI.movie_url("123"), %{format: "json"}),
          1
        )
      end
    end

    test "returns and logs error when the response is a valid json but the API for some reason changed the format of the release date" do
      body = %{
        "director" => "George Lucas",
        "release_date" => "05/06/2002",
        "title" => "Attack of the Clones",
        "url" => "https://swapi.py4e.com/api/films/5/"
      }

      json_body = Jason.encode!(body)
      response = {:ok, %HTTPClientResponse{body: json_body}}

      with_mock(
        HTTPClient,
        get: fn _url, _params ->
          response
        end
      ) do
        assert capture_log(fn ->
                 assert {:error, :api_response_changed} == StarWarsPublicAPI.get_movie("123")
               end) =~ inspect(body)

        assert_called_exactly(
          HTTPClient.get(StarWarsPublicAPI.movie_url("123"), %{format: "json"}),
          1
        )
      end
    end

    test "returns movie response when is successful" do
      body = %{
        "characters" => [
          "https://swapi.py4e.com/api/people/2/",
          "https://swapi.py4e.com/api/people/3/",
          "https://swapi.py4e.com/api/people/6/",
          "https://swapi.py4e.com/api/people/7/",
          "https://swapi.py4e.com/api/people/10/",
          "https://swapi.py4e.com/api/people/11/",
          "https://swapi.py4e.com/api/people/20/",
          "https://swapi.py4e.com/api/people/21/",
          "https://swapi.py4e.com/api/people/22/",
          "https://swapi.py4e.com/api/people/33/",
          "https://swapi.py4e.com/api/people/35/",
          "https://swapi.py4e.com/api/people/36/",
          "https://swapi.py4e.com/api/people/40/",
          "https://swapi.py4e.com/api/people/43/",
          "https://swapi.py4e.com/api/people/46/",
          "https://swapi.py4e.com/api/people/51/",
          "https://swapi.py4e.com/api/people/52/",
          "https://swapi.py4e.com/api/people/53/",
          "https://swapi.py4e.com/api/people/58/",
          "https://swapi.py4e.com/api/people/59/",
          "https://swapi.py4e.com/api/people/60/",
          "https://swapi.py4e.com/api/people/61/",
          "https://swapi.py4e.com/api/people/62/",
          "https://swapi.py4e.com/api/people/63/",
          "https://swapi.py4e.com/api/people/64/",
          "https://swapi.py4e.com/api/people/65/",
          "https://swapi.py4e.com/api/people/66/",
          "https://swapi.py4e.com/api/people/67/",
          "https://swapi.py4e.com/api/people/68/",
          "https://swapi.py4e.com/api/people/69/",
          "https://swapi.py4e.com/api/people/70/",
          "https://swapi.py4e.com/api/people/71/",
          "https://swapi.py4e.com/api/people/72/",
          "https://swapi.py4e.com/api/people/73/",
          "https://swapi.py4e.com/api/people/74/",
          "https://swapi.py4e.com/api/people/75/",
          "https://swapi.py4e.com/api/people/76/"
        ],
        "created" => "2014-12-20T10:57:57.886000Z",
        "director" => "George Lucas",
        "edited" => "2014-12-20T20:18:48.516000Z",
        "episode_id" => 2,
        "opening_crawl" =>
          "There is unrest in the Galactic\r\nSenate. Several thousand solar\r\nsystems have declared their\r\nintentions to leave the Republic.\r\n\r\nThis separatist movement,\r\nunder the leadership of the\r\nmysterious Count Dooku, has\r\nmade it difficult for the limited\r\nnumber of Jedi Knights to maintain \r\npeace and order in the galaxy.\r\n\r\nSenator Amidala, the former\r\nQueen of Naboo, is returning\r\nto the Galactic Senate to vote\r\non the critical issue of creating\r\nan ARMY OF THE REPUBLIC\r\nto assist the overwhelmed\r\nJedi....",
        "planets" => [
          "https://swapi.py4e.com/api/planets/1/",
          "https://swapi.py4e.com/api/planets/8/",
          "https://swapi.py4e.com/api/planets/9/",
          "https://swapi.py4e.com/api/planets/10/",
          "https://swapi.py4e.com/api/planets/11/"
        ],
        "producer" => "Rick McCallum",
        "release_date" => "2002-05-16",
        "species" => [
          "https://swapi.py4e.com/api/species/1/",
          "https://swapi.py4e.com/api/species/2/",
          "https://swapi.py4e.com/api/species/6/",
          "https://swapi.py4e.com/api/species/12/",
          "https://swapi.py4e.com/api/species/13/",
          "https://swapi.py4e.com/api/species/15/",
          "https://swapi.py4e.com/api/species/28/",
          "https://swapi.py4e.com/api/species/29/",
          "https://swapi.py4e.com/api/species/30/",
          "https://swapi.py4e.com/api/species/31/",
          "https://swapi.py4e.com/api/species/32/",
          "https://swapi.py4e.com/api/species/33/",
          "https://swapi.py4e.com/api/species/34/",
          "https://swapi.py4e.com/api/species/35/"
        ],
        "starships" => [
          "https://swapi.py4e.com/api/starships/21/",
          "https://swapi.py4e.com/api/starships/32/",
          "https://swapi.py4e.com/api/starships/39/",
          "https://swapi.py4e.com/api/starships/43/",
          "https://swapi.py4e.com/api/starships/47/",
          "https://swapi.py4e.com/api/starships/48/",
          "https://swapi.py4e.com/api/starships/49/",
          "https://swapi.py4e.com/api/starships/52/",
          "https://swapi.py4e.com/api/starships/58/"
        ],
        "title" => "Attack of the Clones",
        "url" => "https://swapi.py4e.com/api/films/5/",
        "vehicles" => [
          "https://swapi.py4e.com/api/vehicles/4/",
          "https://swapi.py4e.com/api/vehicles/44/",
          "https://swapi.py4e.com/api/vehicles/45/",
          "https://swapi.py4e.com/api/vehicles/46/",
          "https://swapi.py4e.com/api/vehicles/50/",
          "https://swapi.py4e.com/api/vehicles/51/",
          "https://swapi.py4e.com/api/vehicles/53/",
          "https://swapi.py4e.com/api/vehicles/54/",
          "https://swapi.py4e.com/api/vehicles/55/",
          "https://swapi.py4e.com/api/vehicles/56/",
          "https://swapi.py4e.com/api/vehicles/57/"
        ]
      }

      json_body = Jason.encode!(body)
      response = {:ok, %HTTPClientResponse{body: json_body}}

      with_mock(
        HTTPClient,
        get: fn _url, _params ->
          response
        end
      ) do
        assert {:ok,
                %StarWars.IntegrationSource.MovieResponse{
                  title: "Attack of the Clones",
                  release_date: ~D[2002-05-16],
                  integration_source: :star_wars_public_api,
                  integration_id: "5",
                  director: %StarWars.IntegrationSource.MovieDirectorResponse{
                    name: "George Lucas",
                    integration_source: :star_wars_public_api
                  }
                }} == StarWarsPublicAPI.get_movie("1")

        assert_called_exactly(
          HTTPClient.get(StarWarsPublicAPI.movie_url("1"), %{format: "json"}),
          1
        )
      end
    end

    test "returns movie response and trims director name when is successful" do
      body = %{
        "director" => "  George Lucas   ",
        "release_date" => "2002-05-16",
        "title" => "Attack of the Clones",
        "url" => "https://swapi.py4e.com/api/films/5/"
      }

      json_body = Jason.encode!(body)
      response = {:ok, %HTTPClientResponse{body: json_body}}

      with_mock(
        HTTPClient,
        get: fn _url, _params ->
          response
        end
      ) do
        assert {:ok,
                %StarWars.IntegrationSource.MovieResponse{
                  title: "Attack of the Clones",
                  release_date: ~D[2002-05-16],
                  integration_source: :star_wars_public_api,
                  integration_id: "5",
                  director: %StarWars.IntegrationSource.MovieDirectorResponse{
                    name: "George Lucas",
                    integration_source: :star_wars_public_api
                  }
                }} == StarWarsPublicAPI.get_movie("1")

        assert_called_exactly(
          HTTPClient.get(StarWarsPublicAPI.movie_url("1"), %{format: "json"}),
          1
        )
      end
    end
  end
end

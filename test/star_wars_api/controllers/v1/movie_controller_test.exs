defmodule StarWarsAPI.V1.MovieControllerTest do
  use StarWarsAPI.ConnCase

  alias CleanArchitecture.Pagination
  alias StarWarsAPI.V1.MovieSerializer

  alias StarWars.Repo

  defp movie_fixture(attrs \\ %{}) do
    Factory.insert(:movie, attrs)
    |> Repo.preload([:director])
  end

  describe "index" do
    test "returns 200 with empty list when does not have movies created", %{conn: conn} do
      conn = get(conn, Routes.v1_movie_path(conn, :index))
      body = response(conn, 200)

      assert {"content-type", "application/json; charset=utf-8"} in conn.resp_headers

      expected_body =
        %Pagination{entries: [], page_number: 1, page_size: 10, total_entries: 0, total_pages: 0}
        |> MovieSerializer.serialize()
        |> Jason.encode!()

      assert body == expected_body
    end

    test "returns 200 with movies list", %{conn: conn} do
      one = movie_fixture(%{title: "A"})
      two = movie_fixture(%{title: "B"})

      conn = get(conn, Routes.v1_movie_path(conn, :index))

      assert {"content-type", "application/json; charset=utf-8"} in conn.resp_headers

      body = response(conn, 200)

      expected_body =
        %Pagination{
          entries: [two, one],
          page_number: 1,
          page_size: 10,
          total_entries: 2,
          total_pages: 1
        }
        |> MovieSerializer.serialize()
        |> Jason.encode!()

      assert body == expected_body
    end

    test "excludes deleted records from list", %{conn: conn} do
      one = movie_fixture(%{title: "A"})
      _deleted = movie_fixture(%{title: "B", deleted_at: DateTime.now!("Etc/UTC")})
      two = movie_fixture(%{title: "B"})

      conn = get(conn, Routes.v1_movie_path(conn, :index))

      assert {"content-type", "application/json; charset=utf-8"} in conn.resp_headers

      body = response(conn, 200)

      expected_body =
        %Pagination{
          entries: [two, one],
          page_number: 1,
          page_size: 10,
          total_entries: 2,
          total_pages: 1
        }
        |> MovieSerializer.serialize()
        |> Jason.encode!()

      assert body == expected_body
    end

    test "returns 200 with paginated movies list", %{conn: conn} do
      one = movie_fixture(%{title: "A"})
      _two = movie_fixture(%{title: "B"})

      conn = get conn, Routes.v1_movie_path(conn, :index), %{page: 2, page_size: 1}

      assert {"content-type", "application/json; charset=utf-8"} in conn.resp_headers

      body = response(conn, 200)

      expected_body =
        %Pagination{
          entries: [one],
          page_number: 2,
          page_size: 1,
          total_entries: 2,
          total_pages: 2
        }
        |> MovieSerializer.serialize()
        |> Jason.encode!()

      assert body == expected_body
    end

    test "returns 200 with filtered movies list by title", %{conn: conn} do
      one = movie_fixture(%{title: "A"})
      _two = movie_fixture(%{title: "B"})

      conn = get conn, Routes.v1_movie_path(conn, :index), %{title: "A"}

      assert {"content-type", "application/json; charset=utf-8"} in conn.resp_headers

      body = response(conn, 200)

      expected_body =
        %Pagination{
          entries: [one],
          page_number: 1,
          page_size: 10,
          total_entries: 1,
          total_pages: 1
        }
        |> MovieSerializer.serialize()
        |> Jason.encode!()

      assert body == expected_body
    end
  end

  describe "show" do
    test "returns 200 with movie", %{conn: conn} do
      movie = movie_fixture()

      conn = get(conn, Routes.v1_movie_path(conn, :show, movie.id))

      assert {"content-type", "application/json; charset=utf-8"} in conn.resp_headers

      body = response(conn, 200)

      expected_body =
        movie
        |> MovieSerializer.serialize()
        |> Jason.encode!()

      assert body == expected_body
    end

    test "returns 200 with movie that has deleted director", %{conn: conn} do
      deleted_director = Factory.insert(:movie_director, %{deleted_at: DateTime.now!("Etc/UTC")})
      movie = movie_fixture(%{director: deleted_director})

      conn = get(conn, Routes.v1_movie_path(conn, :show, movie.id))

      assert {"content-type", "application/json; charset=utf-8"} in conn.resp_headers

      body = response(conn, 200)

      expected_body =
        %{movie | director: nil}
        |> MovieSerializer.serialize()
        |> Jason.encode!()

      assert body == expected_body
    end

    test "returns 404 status error when movie id does not exist", %{conn: conn} do
      {_status, _headers, body} =
        assert_error_sent :not_found, fn ->
          get(conn, Routes.v1_movie_path(conn, :show, Ecto.UUID.generate()))
        end

      json_body = Phoenix.json_library().decode!(body)
      assert json_body["errors"]["detail"] == "Not Found"
    end

    test "returns 422 status error when movie id is invalid", %{conn: conn} do
      conn = get(conn, Routes.v1_movie_path(conn, :show, "invalid"))

      json_body = json_response(conn, 422)
      assert json_body == %{"errors" => %{"id" => ["is invalid"]}}
    end
  end
end

defmodule StarWarsAPI.V1.MovieControllerTest do
  use StarWarsAPI.ConnCase

  alias StarWarsAPI.V1.MovieSerializer

  alias StarWars.Repo

  defp movie_fixture(attrs \\ %{}) do
    Factory.insert(:movie, attrs)
    |> Repo.preload([:director])
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

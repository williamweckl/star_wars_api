defmodule StarWarsAPI.V1.PlanetControllerTest do
  use StarWarsAPI.ConnCase

  alias CleanArchitecture.Pagination
  alias StarWarsAPI.V1.PlanetSerializer

  alias StarWars.Repo

  defp planet_fixture(attrs) do
    Factory.insert(:planet, attrs)
    |> Repo.preload([:climates, :terrains])
    |> Repo.preload(movies: :director)
  end

  describe "index" do
    test "returns 200 with empty list when does not have planets created", %{conn: conn} do
      conn = get(conn, Routes.v1_planet_path(conn, :index))
      body = response(conn, 200)

      assert {"content-type", "application/json; charset=utf-8"} in conn.resp_headers

      expected_body =
        %Pagination{entries: [], page_number: 1, page_size: 10, total_entries: 0, total_pages: 0}
        |> PlanetSerializer.serialize()
        |> Jason.encode!()

      assert body == expected_body
    end

    test "returns 200 with planets list", %{conn: conn} do
      one = planet_fixture(%{name: "A"})
      two = planet_fixture(%{name: "B"})

      conn = get(conn, Routes.v1_planet_path(conn, :index))

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
        |> PlanetSerializer.serialize()
        |> Jason.encode!()

      assert body == expected_body
    end

    test "excludes deleted records from list", %{conn: conn} do
      one = planet_fixture(%{name: "A"})
      _deleted = planet_fixture(%{name: "B", deleted_at: DateTime.now!("Etc/UTC")})
      two = planet_fixture(%{name: "B"})

      conn = get(conn, Routes.v1_planet_path(conn, :index))

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
        |> PlanetSerializer.serialize()
        |> Jason.encode!()

      assert body == expected_body
    end

    test "returns 200 with paginated planets list", %{conn: conn} do
      one = planet_fixture(%{name: "A"})
      _two = planet_fixture(%{name: "B"})

      conn = get conn, Routes.v1_planet_path(conn, :index), %{page: 2, page_size: 1}

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
        |> PlanetSerializer.serialize()
        |> Jason.encode!()

      assert body == expected_body
    end

    test "returns 200 with filtered planets list by name", %{conn: conn} do
      one = planet_fixture(%{name: "A"})
      _two = planet_fixture(%{name: "B"})

      conn = get conn, Routes.v1_planet_path(conn, :index), %{name: "A"}

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
        |> PlanetSerializer.serialize()
        |> Jason.encode!()

      assert body == expected_body
    end
  end
end

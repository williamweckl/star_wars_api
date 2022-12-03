defmodule StarWarsAPI.HealthCheckControllerTest do
  use StarWarsAPI.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert response(conn, 200) =~ "ok"
  end

  test "GET /v1", %{conn: conn} do
    conn = get(conn, "/v1")
    assert response(conn, 200) =~ "ok"
  end
end

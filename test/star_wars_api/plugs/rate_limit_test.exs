defmodule StarWarsAPI.Plugs.RateLimitTest do
  use StarWarsAPI.ConnCase

  alias StarWarsAPI.Plugs.RateLimit

  describe "init/1" do
    test "returns params" do
      params = %{}
      assert params == RateLimit.init(params)
    end
  end

  describe "call/2" do
    test "when reaching the limit but is not enabled returns conn", %{conn: conn} do
      conn = %Plug.Conn{conn | path_info: ["some", "other", "path"]}

      assert conn ==
               RateLimit.call(conn,
                 interval_ms: 1_000,
                 max_requests: 2,
                 namespace: "x",
                 enabled: false
               )

      assert conn ==
               RateLimit.call(conn,
                 interval_ms: 1_000,
                 max_requests: 2,
                 namespace: "x",
                 enabled: false
               )

      assert conn ==
               RateLimit.call(conn,
                 interval_ms: 1_000,
                 max_requests: 2,
                 namespace: "x",
                 enabled: false
               )
    end

    test "without reaching the limit returns conn", %{conn: conn} do
      conn = %Plug.Conn{conn | path_info: ["some", "path"]}

      assert conn ==
               RateLimit.call(conn, interval_ms: 1, max_requests: 1, namespace: "x", enabled: true)
    end

    test "when reaching the limit returns error", %{conn: conn} do
      conn = %Plug.Conn{conn | path_info: ["some", "other", "path"]}

      assert conn ==
               RateLimit.call(conn,
                 interval_ms: 1_000,
                 max_requests: 2,
                 namespace: "y",
                 enabled: true
               )

      assert conn ==
               RateLimit.call(conn,
                 interval_ms: 1_000,
                 max_requests: 2,
                 namespace: "y",
                 enabled: true
               )

      conn =
        RateLimit.call(conn, interval_ms: 1_000, max_requests: 2, namespace: "y", enabled: true)

      # Halt
      assert conn.state == :sent
      assert json_response(conn, 429)["errors"] != %{}
    end

    test "when reaching the limit but for other namespaces does not returns error", %{
      conn: conn
    } do
      conn = %Plug.Conn{conn | path_info: ["some", "other", "path"]}

      assert conn ==
               RateLimit.call(conn,
                 interval_ms: 1_000,
                 max_requests: 2,
                 namespace: "one",
                 enabled: true
               )

      assert conn ==
               RateLimit.call(conn,
                 interval_ms: 1_000,
                 max_requests: 2,
                 namespace: "one",
                 enabled: true
               )

      assert conn ==
               RateLimit.call(conn,
                 interval_ms: 1_000,
                 max_requests: 2,
                 namespace: "two",
                 enabled: true
               )

      assert conn ==
               RateLimit.call(conn,
                 interval_ms: 1_000,
                 max_requests: 2,
                 namespace: "two",
                 enabled: true
               )

      assert conn ==
               RateLimit.call(conn,
                 interval_ms: 1_000,
                 max_requests: 2,
                 namespace: "three",
                 enabled: true
               )

      assert conn ==
               RateLimit.call(conn,
                 interval_ms: 1_000,
                 max_requests: 2,
                 namespace: "three",
                 enabled: true
               )
    end

    test "when reaching the limit by having different IP addresses but with same forwarded for returns error",
         %{conn: conn} do
      conn = %Plug.Conn{conn | path_info: ["some", "other", "path"]}

      real_ip_address = "191.37.244.135"

      conn =
        conn
        |> Plug.Conn.put_req_header(
          "forwarded",
          "by=3.235.27.148;for=#{real_ip_address};host=api-gateway.duality.gg;proto=http"
        )

      first_conn = %Plug.Conn{conn | remote_ip: {1, 1, 1, 1}}

      assert first_conn ==
               RateLimit.call(first_conn,
                 interval_ms: 1_000,
                 max_requests: 2,
                 namespace: "b",
                 enabled: true
               )

      assert first_conn ==
               RateLimit.call(first_conn,
                 interval_ms: 1_000,
                 max_requests: 2,
                 namespace: "b",
                 enabled: true
               )

      second_conn = %Plug.Conn{conn | remote_ip: {2, 2, 2, 2}}

      second_conn =
        RateLimit.call(second_conn,
          interval_ms: 1_000,
          max_requests: 2,
          namespace: "b",
          enabled: true
        )

      # Halt
      assert second_conn.state == :sent
      assert json_response(second_conn, 429)["errors"] != %{}
    end
  end
end

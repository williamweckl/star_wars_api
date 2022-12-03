defmodule StarWarsAPI.HealthCheckController do
  use Phoenix.Controller, namespace: StarWarsAPI

  import Plug.Conn

  def index(conn, _params) do
    send_resp(conn, 200, "ok")
  end
end

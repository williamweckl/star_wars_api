defmodule StarWarsAPI.Plugs.RateLimit do
  @moduledoc """
  Plug for rate limiting the API.
  """

  use Phoenix.Controller
  import Plug.Conn
  alias StarWarsAPI.ErrorView

  def init(params), do: params

  def call(%Plug.Conn{} = conn,
        interval_ms: _interval_ms,
        max_requests: _max_requests,
        namespace: _namespace,
        enabled: false
      ) do
    # Do nothing, allow execution to continue
    conn
  end

  def call(%Plug.Conn{} = conn,
        interval_ms: interval_ms,
        max_requests: max_requests,
        namespace: namespace,
        enabled: true
      ) do
    options = [interval_ms: interval_ms, max_requests: max_requests, namespace: namespace]

    case check_rate(conn, options) do
      {:allow, _count} ->
        # Do nothing, allow execution to continue
        conn

      {:deny, _limit} ->
        rate_limited_error(conn)
    end
  end

  defp check_rate(
         conn,
         interval_ms: interval_ms,
         max_requests: max_requests,
         namespace: namespace
       ) do
    conn
    |> build_rate_limit_id(namespace)
    |> Hammer.check_rate(interval_ms, max_requests)
  end

  defp build_rate_limit_id(conn, namespace) do
    path = Enum.join(conn.path_info, "/")
    ip = get_remote_ip_from_conn(conn)

    "#{namespace}/#{ip}:#{path}"
  end

  defp get_remote_ip_from_conn(conn) do
    forwarded =
      conn
      |> get_req_header("forwarded")
      |> Enum.at(0)

    forwarded =
      (forwarded || "")
      |> String.split(";")
      |> Enum.find_value(forwarded, fn piece ->
        if String.starts_with?(piece, "for=") do
          String.replace(piece, "for=", "")
        else
          false
        end
      end)

    if forwarded do
      forwarded
    else
      conn.remote_ip |> Tuple.to_list() |> Enum.join(".")
    end
  end

  defp rate_limited_error(conn) do
    conn
    |> put_status(429)
    |> put_view(ErrorView)
    |> render("429.json")
    |> halt()
  end
end

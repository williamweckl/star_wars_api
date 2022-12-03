defmodule StarWars.HTTPClient do
  @moduledoc """
  Wrapper around HTTP client library (HTTPoison).
  """

  alias StarWars.HTTPClientResponse

  def get("" <> url, %{} = params \\ %{}, headers \\ []) when is_list(headers) do
    query_string = URI.encode_query(params)

    headers = [{"Content-Type", "application/json"} | headers]
    response = HTTPoison.get("#{url}?#{query_string}", headers)

    case response do
      {:ok,
       %HTTPoison.Response{status_code: _status_code, body: _body, headers: _headers} = response} ->
        handle_ok_response(response)

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}

      _ ->
        unhandled_response()
    end
  end

  defp handle_ok_response(%HTTPoison.Response{
         status_code: status_code,
         body: body,
         headers: headers
       })
       when is_integer(status_code) and status_code >= 200 and status_code < 300 do
    {:ok, %HTTPClientResponse{status_code: status_code, body: body, headers: headers}}
  end

  defp handle_ok_response(%HTTPoison.Response{
         status_code: status_code,
         body: body,
         headers: headers
       })
       when is_integer(status_code) and status_code >= 300 do
    {:error, %HTTPClientResponse{status_code: status_code, body: body, headers: headers}}
  end

  defp handle_ok_response(_response) do
    unhandled_response()
  end

  defp unhandled_response do
    {:error, :unhandled_response}
  end
end

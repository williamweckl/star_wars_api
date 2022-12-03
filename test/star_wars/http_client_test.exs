defmodule StarWars.HTTPClientTest do
  use StarWars.DataCase

  import Mock

  alias StarWars.HTTPClient
  alias StarWars.HTTPClientResponse

  describe "get/1" do
    test "calls HTTPoison.get with received URL, default query params, default headers and handles success response" do
      url = "https://webhook.site/4514a658-84cb-4206-8fb9-bf1cfa636b11"
      status_code = 200 + :rand.uniform(99)

      with_mock(
        HTTPoison,
        get: fn _url, _headers ->
          httpoison_response = %HTTPoison.Response{
            status_code: status_code,
            body: "ok",
            headers: [{"Content-Type", "text/plain; charset=UTF-8"}]
          }

          {:ok, httpoison_response}
        end
      ) do
        {:ok, response} = HTTPClient.get(url)

        assert %HTTPClientResponse{
                 status_code: status_code,
                 body: "ok",
                 headers: [{"Content-Type", "text/plain; charset=UTF-8"}]
               } == response

        assert_called_exactly(
          HTTPoison.get("#{url}?", [{"Content-Type", "application/json"}]),
          1
        )
      end
    end

    test "calls HTTPoison.get with received URL, default query string, default headers and handles redirect response" do
      url = "https://webhook.site/4ea76bbd-d944-463e-9d82-e270c033da62"
      status_code = 300 + :rand.uniform(99)

      with_mock(
        HTTPoison,
        get: fn _url, _headers ->
          httpoison_response = %HTTPoison.Response{
            status_code: status_code,
            body: "",
            headers: [{"Content-Type", "text/plain"}]
          }

          {:ok, httpoison_response}
        end
      ) do
        {:error, response} = HTTPClient.get(url)

        assert %HTTPClientResponse{
                 status_code: status_code,
                 body: "",
                 headers: [{"Content-Type", "text/plain"}]
               } == response

        assert_called_exactly(
          HTTPoison.get("#{url}?", [{"Content-Type", "application/json"}]),
          1
        )
      end
    end

    test "calls HTTPoison.get with received URL, default query string, default headers and handles 4xx error response" do
      url = "https://webhook.site/4ea76bbd-d944-463e-9d82-e270c033da62"
      status_code = 400 + :rand.uniform(99)

      with_mock(
        HTTPoison,
        get: fn _url, _headers ->
          httpoison_response = %HTTPoison.Response{
            status_code: status_code,
            body: "Invalid",
            headers: [{"Content-Type", "text/plain"}]
          }

          {:ok, httpoison_response}
        end
      ) do
        {:error, response} = HTTPClient.get(url)

        assert %HTTPClientResponse{
                 status_code: status_code,
                 body: "Invalid",
                 headers: [{"Content-Type", "text/plain"}]
               } == response

        assert_called_exactly(
          HTTPoison.get("#{url}?", [{"Content-Type", "application/json"}]),
          1
        )
      end
    end

    test "calls HTTPoison.get with received URL, default query string, default headers and handles 5xx error response" do
      url = "https://webhook.site/4ea76bbd-d944-463e-9d82-e270c033da62"
      status_code = 500 + :rand.uniform(99)

      with_mock(
        HTTPoison,
        get: fn _url, _headers ->
          httpoison_response = %HTTPoison.Response{
            status_code: status_code,
            body: "Error!",
            headers: [{"Content-Type", "text/plain"}]
          }

          {:ok, httpoison_response}
        end
      ) do
        {:error, response} = HTTPClient.get(url)

        assert %HTTPClientResponse{
                 status_code: status_code,
                 body: "Error!",
                 headers: [{"Content-Type", "text/plain"}]
               } == response

        assert_called_exactly(
          HTTPoison.get("#{url}?", [{"Content-Type", "application/json"}]),
          1
        )
      end
    end

    test "calls HTTPoison.get with received URL, default query string, default headers and handles error" do
      url = "https://webhook.site/4ea76bbd-d944-463e-9d82-e270c033da62"

      with_mock(
        HTTPoison,
        get: fn _url, _headers ->
          httpoison_response = %HTTPoison.Error{reason: "timeout"}

          {:error, httpoison_response}
        end
      ) do
        assert {:error, "timeout"} == HTTPClient.get(url)

        assert_called_exactly(
          HTTPoison.get("#{url}?", [{"Content-Type", "application/json"}]),
          1
        )
      end
    end

    test "calls HTTPoison.get with received URL, default query string, default headers and handles invalid format response" do
      url = "https://webhook.site/4ea76bbd-d944-463e-9d82-e270c033da62"

      with_mock(
        HTTPoison,
        get: fn _url, _headers ->
          httpoison_response = %HTTPoison.Response{
            status_code: "invalid"
          }

          {:ok, httpoison_response}
        end
      ) do
        assert {:error, :unhandled_response} == HTTPClient.get(url)

        assert_called_exactly(
          HTTPoison.get("#{url}?", [{"Content-Type", "application/json"}]),
          1
        )
      end
    end

    test "calls HTTPoison.get with received URL, default query string, default headers and handles invalid format" do
      url = "https://webhook.site/4ea76bbd-d944-463e-9d82-e270c033da62"

      with_mock(
        HTTPoison,
        get: fn _url, _headers ->
          {:ok, "some invalid response"}
        end
      ) do
        assert {:error, :unhandled_response} == HTTPClient.get(url)

        assert_called_exactly(
          HTTPoison.get("#{url}?", [{"Content-Type", "application/json"}]),
          1
        )
      end
    end
  end

  describe "get/2" do
    test "calls HTTPoison.get with received URL, query params, default headers and handles success response" do
      url = "https://webhook.site/4514a658-84cb-4206-8fb9-bf1cfa636b11"
      params = %{some: "params"}
      status_code = 200 + :rand.uniform(99)

      with_mock(
        HTTPoison,
        get: fn _url, _headers ->
          httpoison_response = %HTTPoison.Response{
            status_code: status_code,
            body: "ok",
            headers: [{"Content-Type", "text/plain; charset=UTF-8"}]
          }

          {:ok, httpoison_response}
        end
      ) do
        {:ok, response} = HTTPClient.get(url, params)

        assert %HTTPClientResponse{
                 status_code: status_code,
                 body: "ok",
                 headers: [{"Content-Type", "text/plain; charset=UTF-8"}]
               } == response

        assert_called_exactly(
          HTTPoison.get("#{url}?some=params", [{"Content-Type", "application/json"}]),
          1
        )
      end
    end

    test "calls HTTPoison.get with received URL, query params, default headers and handles redirect response" do
      url = "https://webhook.site/4ea76bbd-d944-463e-9d82-e270c033da62"
      params = %{a: "b"}
      status_code = 300 + :rand.uniform(99)

      with_mock(
        HTTPoison,
        get: fn _url, _headers ->
          httpoison_response = %HTTPoison.Response{
            status_code: status_code,
            body: "",
            headers: [{"Content-Type", "text/plain"}]
          }

          {:ok, httpoison_response}
        end
      ) do
        {:error, response} = HTTPClient.get(url, params)

        assert %HTTPClientResponse{
                 status_code: status_code,
                 body: "",
                 headers: [{"Content-Type", "text/plain"}]
               } == response

        assert_called_exactly(
          HTTPoison.get("#{url}?a=b", [{"Content-Type", "application/json"}]),
          1
        )
      end
    end

    test "calls HTTPoison.get with received URL, query params, default headers and handles 4xx error response" do
      url = "https://webhook.site/4ea76bbd-d944-463e-9d82-e270c033da62"
      params = %{c: "d"}
      status_code = 400 + :rand.uniform(99)

      with_mock(
        HTTPoison,
        get: fn _url, _headers ->
          httpoison_response = %HTTPoison.Response{
            status_code: status_code,
            body: "Invalid",
            headers: [{"Content-Type", "text/plain"}]
          }

          {:ok, httpoison_response}
        end
      ) do
        {:error, response} = HTTPClient.get(url, params)

        assert %HTTPClientResponse{
                 status_code: status_code,
                 body: "Invalid",
                 headers: [{"Content-Type", "text/plain"}]
               } == response

        assert_called_exactly(
          HTTPoison.get("#{url}?c=d", [{"Content-Type", "application/json"}]),
          1
        )
      end
    end

    test "calls HTTPoison.get with received URL, query params, default headers and handles 5xx error response" do
      url = "https://webhook.site/4ea76bbd-d944-463e-9d82-e270c033da62"
      params = %{}
      status_code = 500 + :rand.uniform(99)

      with_mock(
        HTTPoison,
        get: fn _url, _headers ->
          httpoison_response = %HTTPoison.Response{
            status_code: status_code,
            body: "Error!",
            headers: [{"Content-Type", "text/plain"}]
          }

          {:ok, httpoison_response}
        end
      ) do
        {:error, response} = HTTPClient.get(url, params)

        assert %HTTPClientResponse{
                 status_code: status_code,
                 body: "Error!",
                 headers: [{"Content-Type", "text/plain"}]
               } == response

        assert_called_exactly(
          HTTPoison.get("#{url}?", [{"Content-Type", "application/json"}]),
          1
        )
      end
    end

    test "calls HTTPoison.get with received URL, query params, default headers and handles error" do
      url = "https://webhook.site/4ea76bbd-d944-463e-9d82-e270c033da62"
      params = %{some: "params"}

      with_mock(
        HTTPoison,
        get: fn _url, _headers ->
          httpoison_response = %HTTPoison.Error{reason: "timeout"}

          {:error, httpoison_response}
        end
      ) do
        assert {:error, "timeout"} == HTTPClient.get(url, params)

        assert_called_exactly(
          HTTPoison.get("#{url}?some=params", [{"Content-Type", "application/json"}]),
          1
        )
      end
    end

    test "calls HTTPoison.get with received URL, query params, default headers and handles invalid format response" do
      url = "https://webhook.site/4ea76bbd-d944-463e-9d82-e270c033da62"
      params = %{some: "params"}

      with_mock(
        HTTPoison,
        get: fn _url, _headers ->
          httpoison_response = %HTTPoison.Response{
            status_code: "invalid"
          }

          {:ok, httpoison_response}
        end
      ) do
        assert {:error, :unhandled_response} == HTTPClient.get(url, params)

        assert_called_exactly(
          HTTPoison.get("#{url}?some=params", [{"Content-Type", "application/json"}]),
          1
        )
      end
    end

    test "calls HTTPoison.get with received URL, query params, default headers and handles invalid format" do
      url = "https://webhook.site/4ea76bbd-d944-463e-9d82-e270c033da62"
      params = %{some: "params"}

      with_mock(
        HTTPoison,
        get: fn _url, _headers ->
          {:ok, "some invalid response"}
        end
      ) do
        assert {:error, :unhandled_response} == HTTPClient.get(url, params)

        assert_called_exactly(
          HTTPoison.get("#{url}?some=params", [{"Content-Type", "application/json"}]),
          1
        )
      end
    end
  end

  describe "get/3" do
    test "calls HTTPoison.get with received URL, query params, headers and handles success response" do
      url = "https://webhook.site/4514a658-84cb-4206-8fb9-bf1cfa636b11"
      params = %{some: "params"}
      headers = [{"Accept-Language", "en-US"}]
      status_code = 200 + :rand.uniform(99)

      with_mock(
        HTTPoison,
        get: fn _url, _headers ->
          httpoison_response = %HTTPoison.Response{
            status_code: status_code,
            body: "ok",
            headers: [{"Content-Type", "text/plain; charset=UTF-8"}]
          }

          {:ok, httpoison_response}
        end
      ) do
        {:ok, response} = HTTPClient.get(url, params, headers)

        assert %HTTPClientResponse{
                 status_code: status_code,
                 body: "ok",
                 headers: [{"Content-Type", "text/plain; charset=UTF-8"}]
               } == response

        assert_called_exactly(
          HTTPoison.get(
            "#{url}?some=params",
            [{"Content-Type", "application/json"} | headers]
          ),
          1
        )
      end
    end

    test "calls HTTPoison.get with received URL, query params, headers and handles redirect response" do
      url = "https://webhook.site/4ea76bbd-d944-463e-9d82-e270c033da62"
      params = %{a: "b"}
      headers = [{"Accept-Language", "pt"}]
      status_code = 300 + :rand.uniform(99)

      with_mock(
        HTTPoison,
        get: fn _url, _headers ->
          httpoison_response = %HTTPoison.Response{
            status_code: status_code,
            body: "",
            headers: [{"Content-Type", "text/plain"}]
          }

          {:ok, httpoison_response}
        end
      ) do
        {:error, response} = HTTPClient.get(url, params, headers)

        assert %HTTPClientResponse{
                 status_code: status_code,
                 body: "",
                 headers: [{"Content-Type", "text/plain"}]
               } == response

        assert_called_exactly(
          HTTPoison.get("#{url}?a=b", [
            {"Content-Type", "application/json"} | headers
          ]),
          1
        )
      end
    end

    test "calls HTTPoison.get with received URL, query params, headers and handles 4xx error response" do
      url = "https://webhook.site/4ea76bbd-d944-463e-9d82-e270c033da62"
      params = %{c: "d"}
      headers = [{"Accept-Language", "pt-BR"}]
      status_code = 400 + :rand.uniform(99)

      with_mock(
        HTTPoison,
        get: fn _url, _headers ->
          httpoison_response = %HTTPoison.Response{
            status_code: status_code,
            body: "Invalid",
            headers: [{"Content-Type", "text/plain"}]
          }

          {:ok, httpoison_response}
        end
      ) do
        {:error, response} = HTTPClient.get(url, params, headers)

        assert %HTTPClientResponse{
                 status_code: status_code,
                 body: "Invalid",
                 headers: [{"Content-Type", "text/plain"}]
               } == response

        assert_called_exactly(
          HTTPoison.get("#{url}?c=d", [
            {"Content-Type", "application/json"} | headers
          ]),
          1
        )
      end
    end

    test "calls HTTPoison.get with received URL, query params, headers and handles 5xx error response" do
      url = "https://webhook.site/4ea76bbd-d944-463e-9d82-e270c033da62"
      params = %{}
      headers = [{"Accept-Language", "es"}]
      status_code = 500 + :rand.uniform(99)

      with_mock(
        HTTPoison,
        get: fn _url, _headers ->
          httpoison_response = %HTTPoison.Response{
            status_code: status_code,
            body: "Error!",
            headers: [{"Content-Type", "text/plain"}]
          }

          {:ok, httpoison_response}
        end
      ) do
        {:error, response} = HTTPClient.get(url, params, headers)

        assert %HTTPClientResponse{
                 status_code: status_code,
                 body: "Error!",
                 headers: [{"Content-Type", "text/plain"}]
               } == response

        assert_called_exactly(
          HTTPoison.get("#{url}?", [
            {"Content-Type", "application/json"} | headers
          ]),
          1
        )
      end
    end

    test "calls HTTPoison.get with received URL, query params, headers and handles error" do
      url = "https://webhook.site/4ea76bbd-d944-463e-9d82-e270c033da62"
      params = %{some: "params"}
      headers = [{"Accept-Language", "en-US"}]

      with_mock(
        HTTPoison,
        get: fn _url, _headers ->
          httpoison_response = %HTTPoison.Error{reason: "timeout"}

          {:error, httpoison_response}
        end
      ) do
        assert {:error, "timeout"} == HTTPClient.get(url, params, headers)

        assert_called_exactly(
          HTTPoison.get("#{url}?some=params", [
            {"Content-Type", "application/json"} | headers
          ]),
          1
        )
      end
    end

    test "calls HTTPoison.get with received URL, query params, headers and handles invalid format response" do
      url = "https://webhook.site/4ea76bbd-d944-463e-9d82-e270c033da62"
      params = %{some: "params"}
      headers = [{"Accept-Language", "en-US"}]

      with_mock(
        HTTPoison,
        get: fn _url, _headers ->
          httpoison_response = %HTTPoison.Response{
            status_code: "invalid"
          }

          {:ok, httpoison_response}
        end
      ) do
        assert {:error, :unhandled_response} == HTTPClient.get(url, params, headers)

        assert_called_exactly(
          HTTPoison.get("#{url}?some=params", [
            {"Content-Type", "application/json"} | headers
          ]),
          1
        )
      end
    end

    test "calls HTTPoison.get with received URL, query params, headers and handles invalid format" do
      url = "https://webhook.site/4ea76bbd-d944-463e-9d82-e270c033da62"
      params = %{some: "params"}
      headers = [{"Accept-Language", "en-US"}]

      with_mock(
        HTTPoison,
        get: fn _url, _headers ->
          {:ok, "some invalid response"}
        end
      ) do
        assert {:error, :unhandled_response} == HTTPClient.get(url, params, headers)

        assert_called_exactly(
          HTTPoison.get("#{url}?some=params", [
            {"Content-Type", "application/json"} | headers
          ]),
          1
        )
      end
    end
  end
end

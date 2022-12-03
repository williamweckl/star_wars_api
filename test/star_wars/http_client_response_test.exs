defmodule StarWars.HTTPClientResponseTest do
  use StarWars.DataCase

  alias StarWars.HTTPClientResponse

  describe "struct" do
    test "defaults attributes to nil" do
      response = %HTTPClientResponse{}

      assert nil == response.status_code
      assert nil == response.body
      assert nil == response.headers
    end

    test "accepts attributes" do
      response = %HTTPClientResponse{status_code: 200, body: "somebody", headers: "someheaders"}

      assert 200 == response.status_code
      assert "somebody" == response.body
      assert "someheaders" == response.headers
    end
  end
end

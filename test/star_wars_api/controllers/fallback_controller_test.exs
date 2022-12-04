defmodule StarWarsAPI.FallbackControllerTest do
  use StarWarsAPI.ConnCase

  alias StarWarsAPI.FallbackController

  describe "call" do
    test "returns 422 status with errors when is called with {:error, changeset}", %{
      conn: conn
    } do
      changeset = %Ecto.Changeset{
        action: nil,
        changes: %{},
        errors: [name: {"can't be blank", [validation: :required]}],
        types: [],
        valid?: false
      }

      conn = FallbackController.call(conn, {:error, changeset})
      json_body = json_response(conn, 422)

      assert json_body["errors"] == %{"name" => ["can't be blank"]}
    end
  end
end

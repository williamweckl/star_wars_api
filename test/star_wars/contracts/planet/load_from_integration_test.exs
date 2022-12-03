defmodule StarWars.Contracts.Planet.LoadFromIntegrationTest do
  use StarWars.DataCase

  alias StarWars.Contracts.Planet.LoadFromIntegration

  @valid_attrs %{
    integration_source:
      StarWars.Enums.IntegrationSource.__enum_map__() |> Keyword.keys() |> Enum.random(),
    integration_id: "1"
  }

  describe "changeset" do
    test "creates valid changeset when all parameters are valid" do
      changeset = LoadFromIntegration.changeset(@valid_attrs)

      assert changeset.valid?
    end

    test "returns error when changeset is missing any required field" do
      changeset = LoadFromIntegration.changeset(%{})

      assert Enum.sort(changeset.errors) ==
               Enum.sort(
                 integration_source: {"can't be blank", [validation: :required]},
                 integration_id: {"can't be blank", [validation: :required]}
               )
    end

    test "returns error when integration_source is invalid" do
      attrs = Map.put(@valid_attrs, :integration_source, "invalid")
      changeset = LoadFromIntegration.changeset(attrs)

      assert "is invalid" in errors_on(changeset).integration_source
    end
  end
end

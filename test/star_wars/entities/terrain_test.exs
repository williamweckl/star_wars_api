defmodule StarWars.Entities.TerrainTest do
  use StarWars.DataCase

  alias StarWars.Entities.Terrain

  @valid_attrs %{
    id: "ocean",
    name: "Ocean",
    integration_source:
      StarWars.Enums.IntegrationSource.__enum_map__() |> Keyword.keys() |> Enum.random()
  }

  describe "changeset" do
    test "creates a changeset when no parameters was informed" do
      changeset = Terrain.changeset()

      refute changeset.valid?
      assert changeset.changes == %{}
    end

    test "creates a changeset when just the schema was informed" do
      changeset = Terrain.changeset(%Terrain{})

      refute changeset.valid?
      assert changeset.changes == %{}
    end

    test "creates valid changeset when all parameters are valid" do
      changeset = Terrain.changeset(@valid_attrs)

      assert changeset.valid?
    end

    test "returns error when changeset is missing required fields" do
      changeset = Terrain.changeset(%{})

      assert changeset.errors == [
               id: {"can't be blank", [validation: :required]},
               name: {"can't be blank", [validation: :required]},
               integration_source: {"can't be blank", [validation: :required]}
             ]
    end

    test "returns data correctly when it's updated" do
      terrain =
        Factory.build(:terrain, %{
          id: "arid",
          name: "Arid",
          integration_source: "star_wars_public_api"
        })

      updated_changeset = Terrain.changeset(terrain, @valid_attrs)

      assert updated_changeset.changes == %{
               id: @valid_attrs.id,
               name: @valid_attrs.name,
               integration_source: @valid_attrs.integration_source
             }
    end

    test "returns error when integration_source is invalid" do
      attrs = Map.put(@valid_attrs, :integration_source, "invalid")
      changeset = Terrain.changeset(attrs)

      assert "is invalid" in errors_on(changeset).integration_source
    end

    test "returns error when name has invalid length" do
      attrs = %{@valid_attrs | name: "#{String.duplicate("a", 61)}"}
      changeset = %Terrain{} |> Terrain.changeset(attrs)
      assert "should be at most 60 character(s)" in errors_on(changeset).name

      attrs = %{@valid_attrs | name: "#{String.duplicate("a", 1)}"}
      changeset = %Terrain{} |> Terrain.changeset(attrs)
      assert "should be at least 2 character(s)" in errors_on(changeset).name
    end
  end
end

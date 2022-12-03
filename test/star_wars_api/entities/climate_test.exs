defmodule StarWarsAPI.Entities.ClimateTest do
  use StarWarsAPI.DataCase

  alias StarWarsAPI.Entities.Climate

  @valid_attrs %{
    id: "temperate",
    name: "Temperate",
    integration_source:
      StarWarsAPI.Enums.IntegrationSource.__enum_map__() |> Keyword.keys() |> Enum.random()
  }

  describe "changeset" do
    test "creates a changeset when no parameters was informed" do
      changeset = Climate.changeset()

      refute changeset.valid?
      assert changeset.changes == %{}
    end

    test "creates a changeset when just the schema was informed" do
      changeset = Climate.changeset(%Climate{})

      refute changeset.valid?
      assert changeset.changes == %{}
    end

    test "creates valid changeset when all parameters are valid" do
      changeset = Climate.changeset(@valid_attrs)

      assert changeset.valid?
    end

    test "returns error when changeset is missing required fields" do
      changeset = Climate.changeset(%{})

      assert changeset.errors == [
               id: {"can't be blank", [validation: :required]},
               name: {"can't be blank", [validation: :required]},
               integration_source: {"can't be blank", [validation: :required]}
             ]
    end

    test "returns data correctly when it's updated" do
      climate =
        Factory.build(:climate, %{
          id: "arid",
          name: "Arid",
          integration_source: "star_wars_public_api"
        })

      updated_changeset = Climate.changeset(climate, @valid_attrs)

      assert updated_changeset.changes == %{
               id: @valid_attrs.id,
               name: @valid_attrs.name,
               integration_source: @valid_attrs.integration_source
             }
    end

    test "returns error when integration_source is invalid" do
      attrs = Map.put(@valid_attrs, :integration_source, "invalid")
      changeset = Climate.changeset(attrs)

      assert "is invalid" in errors_on(changeset).integration_source
    end

    test "returns error when name has invalid length" do
      attrs = %{@valid_attrs | name: "#{String.duplicate("a", 61)}"}
      changeset = %Climate{} |> Climate.changeset(attrs)
      assert "should be at most 60 character(s)" in errors_on(changeset).name

      attrs = %{@valid_attrs | name: "#{String.duplicate("a", 1)}"}
      changeset = %Climate{} |> Climate.changeset(attrs)
      assert "should be at least 2 character(s)" in errors_on(changeset).name
    end
  end
end

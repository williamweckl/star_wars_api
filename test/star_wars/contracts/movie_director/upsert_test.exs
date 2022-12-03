defmodule StarWars.Contracts.MovieDirector.UpsertTest do
  use StarWars.DataCase

  alias StarWars.Contracts.MovieDirector.Upsert

  @valid_attrs %{
    name: "George Lucas",
    integration_source:
      StarWars.Enums.IntegrationSource.__enum_map__() |> Keyword.keys() |> Enum.random()
  }

  describe "changeset" do
    test "creates valid changeset when all parameters are valid" do
      changeset = Upsert.changeset(@valid_attrs)

      assert changeset.valid?
    end

    test "returns error when changeset is missing any required field" do
      changeset = Upsert.changeset(%{})

      assert Enum.sort(changeset.errors) ==
               Enum.sort(
                 name: {"can't be blank", [validation: :required]},
                 integration_source: {"can't be blank", [validation: :required]}
               )
    end

    test "returns error when integration_source is invalid" do
      attrs = Map.put(@valid_attrs, :integration_source, "invalid")
      changeset = Upsert.changeset(attrs)

      assert "is invalid" in errors_on(changeset).integration_source
    end

    test "returns error when name has invalid length" do
      attrs = %{@valid_attrs | name: "#{String.duplicate("a", 256)}"}
      changeset = Upsert.changeset(attrs)
      assert "should be at most 255 character(s)" in errors_on(changeset).name
    end
  end
end

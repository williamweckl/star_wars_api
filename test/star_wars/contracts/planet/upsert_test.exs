defmodule StarWars.Contracts.Planet.UpsertTest do
  use StarWars.DataCase

  alias StarWars.Contracts.Planet.Upsert

  alias StarWars.Entities.Climate
  alias StarWars.Entities.Movie
  alias StarWars.Entities.Terrain

  @valid_attrs %{
    name: "Tatooine",
    integration_source:
      StarWars.Enums.IntegrationSource.__enum_map__() |> Keyword.keys() |> Enum.random(),
    integration_id: "#{:rand.uniform(999_999_999)}",
    climates: [%Climate{id: "arid"}],
    movies: [%Movie{id: Ecto.UUID.generate()}],
    terrains: [%Terrain{id: "ocean"}]
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
                 integration_source: {"can't be blank", [validation: :required]},
                 integration_id: {"can't be blank", [validation: :required]},
                 climates: {"can't be blank", [validation: :required]},
                 movies: {"can't be blank", [validation: :required]},
                 terrains: {"can't be blank", [validation: :required]}
               )
    end

    test "returns error when integration_source is invalid" do
      attrs = Map.put(@valid_attrs, :integration_source, "invalid")
      changeset = Upsert.changeset(attrs)

      assert "is invalid" in errors_on(changeset).integration_source
    end

    test "returns error when name has invalid length" do
      attrs = %{@valid_attrs | name: "#{String.duplicate("a", 61)}"}
      changeset = Upsert.changeset(attrs)
      assert "should be at most 60 character(s)" in errors_on(changeset).name
    end

    test "returns error when climates list is empty" do
      attrs = %{@valid_attrs | climates: []}
      changeset = Upsert.changeset(attrs)
      assert "can't be blank" in errors_on(changeset).climates
    end

    test "returns error when terrains list is empty" do
      attrs = %{@valid_attrs | terrains: []}
      changeset = Upsert.changeset(attrs)
      assert "can't be blank" in errors_on(changeset).terrains
    end

    test "returns error when movies list is empty" do
      attrs = %{@valid_attrs | movies: []}
      changeset = Upsert.changeset(attrs)
      assert "can't be blank" in errors_on(changeset).movies
    end

    test "returns error when climates list is a list of strings" do
      attrs = %{@valid_attrs | climates: ["a", "b"]}
      changeset = Upsert.changeset(attrs)
      assert "is invalid" in errors_on(changeset).climates
    end

    test "returns error when terrains list is a list of strings" do
      attrs = %{@valid_attrs | terrains: ["a", "b"]}
      changeset = Upsert.changeset(attrs)
      assert "is invalid" in errors_on(changeset).terrains
    end

    test "returns error when movies list is a list of strings" do
      attrs = %{@valid_attrs | movies: ["a", "b"]}
      changeset = Upsert.changeset(attrs)
      assert "is invalid" in errors_on(changeset).movies
    end

    test "returns error when climates list is a list of maps that are not climate structs" do
      attrs = %{@valid_attrs | climates: [%{}, %{}]}
      changeset = Upsert.changeset(attrs)
      assert "is invalid" in errors_on(changeset).climates
    end

    test "returns error when terrains list is a list of maps that are not climate structs" do
      attrs = %{@valid_attrs | terrains: [%{}, %{}]}
      changeset = Upsert.changeset(attrs)
      assert "is invalid" in errors_on(changeset).terrains
    end

    test "returns error when movies list is a list of maps that are not climate structs" do
      attrs = %{@valid_attrs | movies: [%{}, %{}]}
      changeset = Upsert.changeset(attrs)
      assert "is invalid" in errors_on(changeset).movies
    end

    test "returns error when climates list is a list of climate structs without id" do
      attrs = %{@valid_attrs | climates: [%Climate{}, %Climate{}]}
      changeset = Upsert.changeset(attrs)
      assert "is invalid" in errors_on(changeset).climates
    end

    test "returns error when terrains list is a list of terrain structs without id" do
      attrs = %{@valid_attrs | terrains: [%Terrain{}, %Terrain{}]}
      changeset = Upsert.changeset(attrs)
      assert "is invalid" in errors_on(changeset).terrains
    end

    test "returns error when movies list is a list of movie structs without id" do
      attrs = %{@valid_attrs | movies: [%Movie{}, %Movie{}]}
      changeset = Upsert.changeset(attrs)
      assert "is invalid" in errors_on(changeset).movies
    end
  end
end

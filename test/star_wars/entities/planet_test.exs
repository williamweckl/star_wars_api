defmodule StarWars.Entities.PlanetTest do
  use StarWars.DataCase

  alias StarWars.Entities.Planet

  @valid_attrs %{
    name: "Tatooine",
    integration_source:
      StarWars.Enums.IntegrationSource.__enum_map__() |> Keyword.keys() |> Enum.random(),
    integration_id: "#{:rand.uniform(999_999_999)}"
  }

  describe "changeset" do
    test "creates a changeset when no parameters was informed" do
      changeset = Planet.changeset()

      refute changeset.valid?
      assert changeset.changes == %{}
    end

    test "creates a changeset when just the schema was informed" do
      changeset = Planet.changeset(%Planet{})

      refute changeset.valid?
      assert changeset.changes == %{}
    end

    test "creates valid changeset when all parameters are valid" do
      changeset = Planet.changeset(@valid_attrs)

      assert changeset.valid?
    end

    test "returns error when changeset is missing required fields" do
      changeset = Planet.changeset(%{})

      assert changeset.errors == [
               name: {"can't be blank", [validation: :required]},
               integration_source: {"can't be blank", [validation: :required]}
             ]
    end

    test "returns data correctly when it's updated" do
      planet =
        Factory.build(:planet, %{
          name: "Alderaan",
          integration_source: "star_wars_public_api",
          integration_id: "321"
        })

      updated_changeset = Planet.changeset(planet, @valid_attrs)

      assert updated_changeset.changes == %{
               name: @valid_attrs.name,
               integration_source: @valid_attrs.integration_source,
               integration_id: @valid_attrs.integration_id
             }
    end

    test "returns error when integration_source is invalid" do
      attrs = Map.put(@valid_attrs, :integration_source, "invalid")
      changeset = Planet.changeset(attrs)

      assert "is invalid" in errors_on(changeset).integration_source
    end

    test "returns error when name has invalid length" do
      attrs = %{@valid_attrs | name: "#{String.duplicate("a", 61)}"}
      changeset = %Planet{} |> Planet.changeset(attrs)
      assert "should be at most 60 character(s)" in errors_on(changeset).name
    end

    test "returns error when integration_id is already taken" do
      planet = Factory.insert(:planet)

      assert {:error, changeset} =
               @valid_attrs
               |> Map.put(:integration_id, planet.integration_id)
               |> Planet.changeset()
               |> Repo.insert()

      assert "has already been taken" in errors_on(changeset).integration_id
    end

    test "does not return error when inserting a non conflicted integration_id" do
      _planet = Factory.insert(:planet)
      other_integration_id = "abc"

      assert {:ok, _record} =
               @valid_attrs
               |> Map.put(:integration_id, other_integration_id)
               |> Planet.changeset()
               |> Repo.insert()
    end

    test "does not return error when integration_id is the same as other deleted planet" do
      planet = Factory.insert(:planet, deleted_at: DateTime.now!("Etc/UTC"))

      assert {:ok, _record} =
               @valid_attrs
               |> Map.put(:integration_id, planet.integration_id)
               |> Planet.changeset()
               |> Repo.insert()
    end

    test "ables to insert related climates" do
      climate_one = Factory.insert(:climate)
      climate_two = Factory.insert(:climate)

      assert {:ok, record} =
               @valid_attrs
               |> Planet.changeset()
               |> put_assoc(:climates, [climate_one, climate_two])
               |> Repo.insert()

      assert record.climates == [climate_one, climate_two]

      reloaded_record = record |> StarWars.Repo.reload!() |> StarWars.Repo.preload(:climates)

      assert Enum.sort(reloaded_record.climates) == Enum.sort([climate_one, climate_two])
    end

    test "ables to insert related movies" do
      movie_one = Factory.insert(:movie) |> StarWars.Repo.reload!()
      movie_two = Factory.insert(:movie) |> StarWars.Repo.reload!()

      assert {:ok, record} =
               @valid_attrs
               |> Planet.changeset()
               |> put_assoc(:movies, [movie_one, movie_two])
               |> Repo.insert()

      assert record.movies == [movie_one, movie_two]

      reloaded_record = record |> StarWars.Repo.reload!() |> StarWars.Repo.preload(:movies)
      assert Enum.sort(reloaded_record.movies) == Enum.sort([movie_one, movie_two])
    end

    test "ables to insert related terrains" do
      terrain_one = Factory.insert(:terrain)
      terrain_two = Factory.insert(:terrain)

      assert {:ok, record} =
               @valid_attrs
               |> Planet.changeset()
               |> put_assoc(:terrains, [terrain_one, terrain_two])
               |> Repo.insert()

      assert record.terrains == [terrain_one, terrain_two]

      reloaded_record = record |> StarWars.Repo.reload!() |> StarWars.Repo.preload(:terrains)

      assert Enum.sort(reloaded_record.terrains) == Enum.sort([terrain_one, terrain_two])
    end
  end
end

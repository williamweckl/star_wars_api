defmodule StarWars.Entities.MovieDirectorTest do
  use StarWars.DataCase

  alias StarWars.Entities.MovieDirector

  @valid_attrs %{
    name: "George Lucas",
    integration_source:
      StarWars.Enums.IntegrationSource.__enum_map__() |> Keyword.keys() |> Enum.random()
  }

  describe "changeset" do
    test "creates a changeset when no parameters was informed" do
      changeset = MovieDirector.changeset()

      refute changeset.valid?
      assert changeset.changes == %{}
    end

    test "creates a changeset when just the schema was informed" do
      changeset = MovieDirector.changeset(%MovieDirector{})

      refute changeset.valid?
      assert changeset.changes == %{}
    end

    test "creates valid changeset when all parameters are valid" do
      changeset = MovieDirector.changeset(@valid_attrs)

      assert changeset.valid?
    end

    test "returns error when changeset is missing required fields" do
      changeset = MovieDirector.changeset(%{})

      assert changeset.errors == [
               name: {"can't be blank", [validation: :required]},
               integration_source: {"can't be blank", [validation: :required]}
             ]
    end

    test "returns data correctly when it's updated" do
      movie_director =
        Factory.build(:movie_director, %{
          name: "Richard Marquand",
          integration_source: "star_wars_public_api"
        })

      updated_changeset = MovieDirector.changeset(movie_director, @valid_attrs)

      assert updated_changeset.changes == %{
               name: @valid_attrs.name,
               integration_source: @valid_attrs.integration_source
             }
    end

    test "returns error when integration_source is invalid" do
      attrs = Map.put(@valid_attrs, :integration_source, "invalid")
      changeset = MovieDirector.changeset(attrs)

      assert "is invalid" in errors_on(changeset).integration_source
    end

    test "returns error when name has invalid length" do
      attrs = %{@valid_attrs | name: "#{String.duplicate("a", 256)}"}
      changeset = %MovieDirector{} |> MovieDirector.changeset(attrs)
      assert "should be at most 255 character(s)" in errors_on(changeset).name
    end

    test "returns error when name is already taken" do
      movie_director = Factory.insert(:movie_director)

      assert {:error, changeset} =
               @valid_attrs
               |> Map.put(:name, movie_director.name)
               |> MovieDirector.changeset()
               |> Repo.insert()

      assert "has already been taken" in errors_on(changeset).name
    end

    test "does not return error when inserting a non conflicted name" do
      _movie_director = Factory.insert(:movie_director)
      other_name = "abc"

      assert {:ok, _record} =
               @valid_attrs
               |> Map.put(:name, other_name)
               |> MovieDirector.changeset()
               |> Repo.insert()
    end

    test "does not return error when name is the same as other deleted movie_director" do
      movie_director = Factory.insert(:movie_director, deleted_at: DateTime.now!("Etc/UTC"))

      assert {:ok, _record} =
               @valid_attrs
               |> Map.put(:name, movie_director.name)
               |> MovieDirector.changeset()
               |> Repo.insert()
    end
  end
end

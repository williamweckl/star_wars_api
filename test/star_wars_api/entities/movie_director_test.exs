defmodule StarWarsAPI.Entities.MovieDirectorTest do
  use StarWarsAPI.DataCase

  alias StarWarsAPI.Entities.MovieDirector

  @valid_attrs %{
    name: "George Lucas",
    integration_source:
      StarWarsAPI.Enums.IntegrationSource.__enum_map__() |> Keyword.keys() |> Enum.random()
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
  end
end

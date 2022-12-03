defmodule StarWarsAPI.Entities.MovieTest do
  use StarWarsAPI.DataCase

  alias StarWarsAPI.Entities.Movie

  @valid_attrs %{
    title: "A New Hope",
    release_date: ~D[2000-01-01],
    integration_source:
      StarWarsAPI.Enums.IntegrationSource.__enum_map__() |> Keyword.keys() |> Enum.random(),
    integration_id: "#{:rand.uniform(999_999_999)}"
  }

  describe "changeset" do
    test "creates a changeset when no parameters was informed" do
      changeset = Movie.changeset()

      refute changeset.valid?
      assert changeset.changes == %{}
    end

    test "creates a changeset when just the schema was informed" do
      changeset = Movie.changeset(%Movie{})

      refute changeset.valid?
      assert changeset.changes == %{}
    end

    test "creates valid changeset when all parameters are valid" do
      changeset = Movie.changeset(@valid_attrs)

      assert changeset.valid?
    end

    test "returns error when changeset is missing required fields" do
      changeset = Movie.changeset(%{})

      assert changeset.errors == [
               title: {"can't be blank", [validation: :required]},
               release_date: {"can't be blank", [validation: :required]},
               integration_source: {"can't be blank", [validation: :required]}
             ]
    end

    test "returns data correctly when it's updated" do
      movie =
        Factory.build(:movie, %{
          title: "The Phantom Menace",
          release_date: ~D[2002-02-02],
          integration_source: "star_wars_public_api",
          integration_id: "321"
        })

      updated_changeset = Movie.changeset(movie, @valid_attrs)

      assert updated_changeset.changes == %{
               title: @valid_attrs.title,
               release_date: @valid_attrs.release_date,
               integration_source: @valid_attrs.integration_source,
               integration_id: @valid_attrs.integration_id
             }
    end

    test "returns error when integration_source is invalid" do
      attrs = Map.put(@valid_attrs, :integration_source, "invalid")
      changeset = Movie.changeset(attrs)

      assert "is invalid" in errors_on(changeset).integration_source
    end

    test "returns error when title has invalid length" do
      attrs = %{@valid_attrs | title: "#{String.duplicate("a", 256)}"}
      changeset = %Movie{} |> Movie.changeset(attrs)
      assert "should be at most 255 character(s)" in errors_on(changeset).title
    end
  end
end

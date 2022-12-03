defmodule StarWars.Contracts.Movie.UpsertTest do
  use StarWars.DataCase

  alias StarWars.Contracts.Movie.Upsert

  @valid_attrs %{
    title: "A New Hope",
    release_date: ~D[2000-01-01],
    integration_source:
      StarWars.Enums.IntegrationSource.__enum_map__() |> Keyword.keys() |> Enum.random(),
    integration_id: "#{:rand.uniform(999_999_999)}",
    director_id: Ecto.UUID.generate()
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
                 title: {"can't be blank", [validation: :required]},
                 release_date: {"can't be blank", [validation: :required]},
                 integration_source: {"can't be blank", [validation: :required]},
                 integration_id: {"can't be blank", [validation: :required]},
                 director_id: {"can't be blank", [validation: :required]}
               )
    end

    test "returns error when integration_source is invalid" do
      attrs = Map.put(@valid_attrs, :integration_source, "invalid")
      changeset = Upsert.changeset(attrs)

      assert "is invalid" in errors_on(changeset).integration_source
    end

    test "returns error when title has invalid length" do
      attrs = %{@valid_attrs | title: "#{String.duplicate("a", 256)}"}
      changeset = Upsert.changeset(attrs)
      assert "should be at most 255 character(s)" in errors_on(changeset).title
    end
  end
end

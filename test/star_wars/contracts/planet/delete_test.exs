defmodule StarWars.Contracts.Planet.DeleteTest do
  use StarWars.DataCase

  alias StarWars.Contracts.Planet.Delete

  @valid_attrs %{
    id: Ecto.UUID.generate(),
    deleted_at: DateTime.now!("Etc/UTC")
  }

  describe "changeset" do
    test "creates valid changeset when all parameters are valid" do
      changeset = Delete.changeset(@valid_attrs)

      assert changeset.valid?
      assert changeset.changes == @valid_attrs
    end

    test "returns error when changeset is missing any required field" do
      changeset = Delete.changeset(%{})

      assert Enum.sort(changeset.errors) ==
               Enum.sort(
                 id: {"can't be blank", [validation: :required]},
                 deleted_at: {"can't be blank", [validation: :required]}
               )
    end
  end
end

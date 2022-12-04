defmodule StarWars.Contracts.Planet.GetTest do
  use StarWars.DataCase

  alias StarWars.Contracts.Planet.Get

  @valid_attrs %{
    id: Ecto.UUID.generate()
  }

  describe "changeset" do
    test "creates valid changeset when all parameters are valid" do
      changeset = Get.changeset(@valid_attrs)

      assert changeset.valid?
      assert changeset.changes == @valid_attrs
    end

    test "returns error when changeset is missing any required field" do
      changeset = Get.changeset(%{})

      assert Enum.sort(changeset.errors) ==
               Enum.sort(id: {"can't be blank", [validation: :required]})
    end
  end
end

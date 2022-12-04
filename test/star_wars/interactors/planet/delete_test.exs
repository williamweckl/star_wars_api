defmodule StarWars.Interactors.Planet.DeleteTest do
  use StarWars.DataCase

  alias StarWars.Interactors.Planet.Delete
  alias StarWars.Repo

  @valid_attrs %{
    id: Ecto.UUID.generate(),
    deleted_at: ~U[2022-12-04 13:38:41.857998Z]
  }

  def fixture(attrs \\ %{}) do
    Factory.insert(:planet, attrs)
  end

  describe "call/1" do
    test "soft deletes the planet" do
      planet = fixture(%{id: @valid_attrs.id})

      assert {:ok, updated_planet} = Delete.call(@valid_attrs)

      assert updated_planet.id == planet.id
      assert updated_planet.name == planet.name
      assert updated_planet.integration_id == planet.integration_id
      assert updated_planet.integration_source == planet.integration_source
      assert updated_planet.inserted_at == planet.inserted_at
      assert updated_planet.updated_at != planet.updated_at
      assert updated_planet.deleted_at == @valid_attrs.deleted_at

      reloaded_planet = updated_planet |> Repo.reload!()

      assert reloaded_planet.id == planet.id
      assert reloaded_planet.name == planet.name
      assert reloaded_planet.integration_id == planet.integration_id
      assert reloaded_planet.integration_source == planet.integration_source
      assert reloaded_planet.inserted_at == planet.inserted_at
      assert reloaded_planet.updated_at != planet.updated_at
      assert reloaded_planet.deleted_at == @valid_attrs.deleted_at
    end

    test "raises not found error when id is not existent" do
      assert_raise Ecto.NoResultsError, fn ->
        Delete.call(@valid_attrs)
      end
    end

    test "raises not found error when planet is already deleted" do
      _planet = fixture(%{id: @valid_attrs.id, deleted_at: DateTime.utc_now()})

      assert_raise Ecto.NoResultsError, fn ->
        Delete.call(@valid_attrs)
      end
    end

    test "returns error when id is in an invalid format" do
      input = %{@valid_attrs | id: "invalid"}

      assert {:error, changeset} = Delete.call(input)
      assert "is invalid" in errors_on(changeset).id
    end

    test "returns error when deleted_at is in an invalid format" do
      _planet = fixture(%{id: @valid_attrs.id})
      input = %{@valid_attrs | deleted_at: "invalid"}

      assert {:error, changeset} = Delete.call(input)
      assert "is invalid" in errors_on(changeset).deleted_at
    end
  end
end

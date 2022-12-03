defmodule StarWars.Interactors.Terrain.UpsertTest do
  use StarWars.DataCase

  alias StarWars.Entities.Terrain

  alias StarWars.Interactors.Terrain.Upsert
  alias StarWars.Repo

  @valid_attrs %{
    id: "ocean",
    name: "Ocean",
    integration_source:
      StarWars.Enums.IntegrationSource.__enum_map__() |> Keyword.keys() |> Enum.random()
  }

  defp terrain_fixture(attrs) do
    Factory.insert(:terrain, attrs)
  end

  defp assert_has_upserted_terrain_attrs(terrain) do
    assert_match = fn terrain ->
      assert terrain.id == @valid_attrs.id
      assert terrain.name == @valid_attrs.name
      assert "#{terrain.integration_source}" == "#{@valid_attrs.integration_source}"
    end

    assert_match.(terrain)

    persisted_terrain = Repo.reload!(terrain)
    assert_match.(persisted_terrain)
  end

  describe "call/1" do
    test "creates a terrain when terrain does not exist yet" do
      assert Repo.aggregate(Terrain, :count, :id) == 0

      assert {:ok, %Terrain{} = terrain} = Upsert.call(@valid_attrs)

      assert_has_upserted_terrain_attrs(terrain)

      assert Repo.aggregate(Terrain, :count, :id) == 1
    end

    test "updates a terrain when terrain already exists" do
      terrain_fixture(%{id: @valid_attrs.id})

      assert Repo.aggregate(Terrain, :count, :id) == 1

      assert {:ok, %Terrain{} = terrain} = Upsert.call(@valid_attrs)

      assert_has_upserted_terrain_attrs(terrain)

      assert Repo.aggregate(Terrain, :count, :id) == 1
    end

    test "updates a terrain when terrain already exists but the id contains empty spaces" do
      terrain_fixture(%{id: @valid_attrs.id})

      assert Repo.aggregate(Terrain, :count, :id) == 1

      assert {:ok, %Terrain{} = terrain} =
               @valid_attrs |> Map.put(:id, " #{@valid_attrs.id}  ") |> Upsert.call()

      assert_has_upserted_terrain_attrs(terrain)

      assert Repo.aggregate(Terrain, :count, :id) == 1
    end

    test "updates a terrain when terrain already exists but the name is upper cased" do
      terrain_fixture(%{id: @valid_attrs.id})

      assert Repo.aggregate(Terrain, :count, :id) == 1

      assert {:ok, %Terrain{} = terrain} =
               @valid_attrs |> Map.put(:id, String.upcase(@valid_attrs.id)) |> Upsert.call()

      assert_has_upserted_terrain_attrs(terrain)

      assert Repo.aggregate(Terrain, :count, :id) == 1
    end

    test "updates a terrain when terrain already exists but the name has spaces" do
      terrain_fixture(%{id: "some_id"})

      assert Repo.aggregate(Terrain, :count, :id) == 1

      assert {:ok, %Terrain{} = terrain} =
               @valid_attrs |> Map.put(:id, "Some ID") |> Upsert.call()

      assert terrain.id == "some_id"
      assert terrain.name == @valid_attrs.name
      assert terrain.deleted_at == nil

      assert Repo.aggregate(Terrain, :count, :id) == 1
    end

    test "does not create terrain when attrs are invalid" do
      attrs = Map.merge(@valid_attrs, %{integration_source: nil})

      assert Repo.aggregate(Terrain, :count, :id) == 0

      assert {:error, %Ecto.Changeset{} = changeset} = Upsert.call(attrs)

      assert "can't be blank" in errors_on(changeset).integration_source

      assert Repo.aggregate(Terrain, :count, :id) == 0
    end

    test "does not update when attrs are invalid" do
      terrain = terrain_fixture(%{id: @valid_attrs.id})

      attrs = Map.merge(@valid_attrs, %{integration_source: nil})

      assert {:error, %Ecto.Changeset{} = changeset} = Upsert.call(attrs)

      assert "can't be blank" in errors_on(changeset).integration_source

      reloaded_terrain = Repo.reload(terrain)

      assert reloaded_terrain.integration_source == terrain.integration_source
    end

    test "updates the terrain when terrain with same id exists but was deleted" do
      deleted_terrain =
        terrain_fixture(%{
          id: @valid_attrs.id,
          deleted_at: DateTime.now!("Etc/UTC")
        })

      assert Repo.aggregate(Terrain, :count, :id) == 1

      assert {:ok, %Terrain{} = terrain} = Upsert.call(@valid_attrs)

      assert terrain.id == deleted_terrain.id
      assert terrain.name == @valid_attrs.name
      assert terrain.deleted_at == deleted_terrain.deleted_at

      assert Repo.aggregate(Terrain, :count, :id) == 1
    end
  end
end

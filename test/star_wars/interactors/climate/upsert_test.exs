defmodule StarWars.Interactors.Climate.UpsertTest do
  use StarWars.DataCase

  alias StarWars.Entities.Climate

  alias StarWars.Interactors.Climate.Upsert
  alias StarWars.Repo

  @valid_attrs %{
    id: "temperate",
    name: "Temperate",
    integration_source:
      StarWars.Enums.IntegrationSource.__enum_map__() |> Keyword.keys() |> Enum.random()
  }

  defp climate_fixture(attrs) do
    Factory.insert(:climate, attrs)
  end

  defp assert_has_upserted_climate_attrs(climate) do
    assert_match = fn climate ->
      assert climate.id == @valid_attrs.id
      assert climate.name == @valid_attrs.name
      assert "#{climate.integration_source}" == "#{@valid_attrs.integration_source}"
    end

    assert_match.(climate)

    persisted_climate = Repo.reload!(climate)
    assert_match.(persisted_climate)
  end

  describe "call/1" do
    test "creates a climate when climate does not exist yet" do
      assert Repo.aggregate(Climate, :count, :id) == 0

      assert {:ok, %Climate{} = climate} = Upsert.call(@valid_attrs)

      assert_has_upserted_climate_attrs(climate)

      assert Repo.aggregate(Climate, :count, :id) == 1
    end

    test "updates a climate when climate already exists" do
      climate_fixture(%{id: @valid_attrs.id})

      assert Repo.aggregate(Climate, :count, :id) == 1

      assert {:ok, %Climate{} = climate} = Upsert.call(@valid_attrs)

      assert_has_upserted_climate_attrs(climate)

      assert Repo.aggregate(Climate, :count, :id) == 1
    end

    test "updates a climate when climate already exists but the id contains empty spaces" do
      climate_fixture(%{id: @valid_attrs.id})

      assert Repo.aggregate(Climate, :count, :id) == 1

      assert {:ok, %Climate{} = climate} =
               @valid_attrs |> Map.put(:id, " #{@valid_attrs.id}  ") |> Upsert.call()

      assert_has_upserted_climate_attrs(climate)

      assert Repo.aggregate(Climate, :count, :id) == 1
    end

    test "updates a climate when climate already exists but the name is upper cased" do
      climate_fixture(%{id: @valid_attrs.id})

      assert Repo.aggregate(Climate, :count, :id) == 1

      assert {:ok, %Climate{} = climate} =
               @valid_attrs |> Map.put(:id, String.upcase(@valid_attrs.id)) |> Upsert.call()

      assert_has_upserted_climate_attrs(climate)

      assert Repo.aggregate(Climate, :count, :id) == 1
    end

    test "updates a climate when climate already exists but the name has spaces" do
      climate_fixture(%{id: "some_id"})

      assert Repo.aggregate(Climate, :count, :id) == 1

      assert {:ok, %Climate{} = climate} =
               @valid_attrs |> Map.put(:id, "Some ID") |> Upsert.call()

      assert climate.id == "some_id"
      assert climate.name == @valid_attrs.name
      assert climate.deleted_at == nil

      assert Repo.aggregate(Climate, :count, :id) == 1
    end

    test "does not create climate when attrs are invalid" do
      attrs = Map.merge(@valid_attrs, %{integration_source: nil})

      assert Repo.aggregate(Climate, :count, :id) == 0

      assert {:error, %Ecto.Changeset{} = changeset} = Upsert.call(attrs)

      assert "can't be blank" in errors_on(changeset).integration_source

      assert Repo.aggregate(Climate, :count, :id) == 0
    end

    test "does not update when attrs are invalid" do
      climate = climate_fixture(%{id: @valid_attrs.id})

      attrs = Map.merge(@valid_attrs, %{integration_source: nil})

      assert {:error, %Ecto.Changeset{} = changeset} = Upsert.call(attrs)

      assert "can't be blank" in errors_on(changeset).integration_source

      reloaded_climate = Repo.reload(climate)

      assert reloaded_climate.integration_source == climate.integration_source
    end

    test "updates the climate when climate with same id exists but was deleted" do
      deleted_climate =
        climate_fixture(%{
          id: @valid_attrs.id,
          deleted_at: DateTime.now!("Etc/UTC")
        })

      assert Repo.aggregate(Climate, :count, :id) == 1

      assert {:ok, %Climate{} = climate} = Upsert.call(@valid_attrs)

      assert climate.id == deleted_climate.id
      assert climate.name == @valid_attrs.name
      assert climate.deleted_at == deleted_climate.deleted_at

      assert Repo.aggregate(Climate, :count, :id) == 1
    end
  end
end

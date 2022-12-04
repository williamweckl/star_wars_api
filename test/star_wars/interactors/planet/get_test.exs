defmodule StarWars.Interactors.Planet.GetTest do
  use StarWars.DataCase

  alias StarWars.Interactors.Planet.Get
  alias StarWars.Repo

  def fixture(attrs \\ %{}) do
    Factory.insert(:planet, attrs)
  end

  describe "call/1" do
    test "returns a planet by the given id" do
      planet = fixture()
      input = %{id: planet.id}

      assert Get.call(input) ==
               planet
               |> Repo.reload!()
               |> Repo.preload([:climates, :terrains])
               |> Repo.preload(movies: :director)
    end

    test "raises cast error when id is in an invalid format" do
      input = %{id: "invalid"}

      assert_raise Ecto.Query.CastError, fn ->
        Get.call(input)
      end
    end

    test "raises not found error when id is not existent" do
      input = %{id: Ecto.UUID.generate()}

      assert_raise Ecto.NoResultsError, fn ->
        Get.call(input)
      end
    end

    test "raises not found error when planet is deleted" do
      planet = fixture(%{deleted_at: DateTime.utc_now()})
      input = %{id: planet.id}

      assert_raise Ecto.NoResultsError, fn ->
        Get.call(input)
      end
    end
  end
end

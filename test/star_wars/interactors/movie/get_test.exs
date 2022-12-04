defmodule StarWars.Interactors.Movie.GetTest do
  use StarWars.DataCase

  alias StarWars.Interactors.Movie.Get
  alias StarWars.Repo

  def fixture(attrs \\ %{}) do
    Factory.insert(:movie, attrs)
  end

  describe "call/1" do
    test "returns a movie by the given id" do
      movie = fixture()
      input = %{id: movie.id}

      assert Get.call(input) ==
               movie
               |> Repo.reload!()
               |> Repo.preload(:director)
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

    test "raises not found error when movie is deleted" do
      movie = fixture(%{deleted_at: DateTime.utc_now()})
      input = %{id: movie.id}

      assert_raise Ecto.NoResultsError, fn ->
        Get.call(input)
      end
    end
  end
end

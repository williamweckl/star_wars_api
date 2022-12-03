defmodule StarWars.Interactors.MovieDirector.UpsertTest do
  use StarWars.DataCase

  alias StarWars.Entities.MovieDirector

  alias StarWars.Interactors.MovieDirector.Upsert
  alias StarWars.Repo

  @valid_attrs %{
    name: "George Lucas",
    integration_source:
      StarWars.Enums.IntegrationSource.__enum_map__() |> Keyword.keys() |> Enum.random()
  }

  defp movie_director_fixture(attrs) do
    Factory.insert(:movie_director, attrs)
  end

  defp assert_has_upserted_movie_director_attrs(movie_director) do
    assert_match = fn movie_director ->
      assert movie_director.name == @valid_attrs.name
      assert "#{movie_director.integration_source}" == "#{@valid_attrs.integration_source}"
    end

    assert_match.(movie_director)

    persisted_movie_director = Repo.reload!(movie_director)
    assert_match.(persisted_movie_director)
  end

  describe "call/1" do
    test "creates a movie_director when movie_director does not exist yet" do
      assert Repo.aggregate(MovieDirector, :count, :id) == 0

      assert {:ok, %MovieDirector{} = movie_director} = Upsert.call(@valid_attrs)

      assert_has_upserted_movie_director_attrs(movie_director)

      assert Repo.aggregate(MovieDirector, :count, :id) == 1
    end

    test "updates a movie_director when movie_director already exists" do
      movie_director_fixture(%{name: @valid_attrs.name})

      assert Repo.aggregate(MovieDirector, :count, :id) == 1

      assert {:ok, %MovieDirector{} = movie_director} = Upsert.call(@valid_attrs)

      assert_has_upserted_movie_director_attrs(movie_director)

      assert Repo.aggregate(MovieDirector, :count, :id) == 1
    end

    test "updates a movie_director when movie_director already exists but the name contains empty spaces" do
      movie_director_fixture(%{name: @valid_attrs.name})

      assert Repo.aggregate(MovieDirector, :count, :id) == 1

      assert {:ok, %MovieDirector{} = movie_director} =
               @valid_attrs |> Map.put(:name, " #{@valid_attrs.name}  ") |> Upsert.call()

      assert_has_upserted_movie_director_attrs(movie_director)

      assert Repo.aggregate(MovieDirector, :count, :id) == 1
    end

    test "updates a movie_director when movie_director already exists but the name is lower cased" do
      movie_director_fixture(%{name: @valid_attrs.name})

      assert Repo.aggregate(MovieDirector, :count, :id) == 1

      assert {:ok, %MovieDirector{} = movie_director} =
               @valid_attrs |> Map.put(:name, String.downcase(@valid_attrs.name)) |> Upsert.call()

      assert_has_upserted_movie_director_attrs(movie_director)

      assert Repo.aggregate(MovieDirector, :count, :id) == 1
    end

    test "does not create movie_director when attrs are invalid" do
      attrs = Map.merge(@valid_attrs, %{integration_source: nil})

      assert Repo.aggregate(MovieDirector, :count, :id) == 0

      assert {:error, %Ecto.Changeset{} = changeset} = Upsert.call(attrs)

      assert "can't be blank" in errors_on(changeset).integration_source

      assert Repo.aggregate(MovieDirector, :count, :id) == 0
    end

    test "does not update when attrs are invalid" do
      movie_director = movie_director_fixture(%{name: @valid_attrs.name})

      attrs = Map.merge(@valid_attrs, %{integration_source: nil})

      assert {:error, %Ecto.Changeset{} = changeset} = Upsert.call(attrs)

      assert "can't be blank" in errors_on(changeset).integration_source

      reloaded_movie_director = Repo.reload(movie_director)

      assert reloaded_movie_director.integration_source == movie_director.integration_source
    end

    test "creates a movie_director when movie_director with same name exists but was deleted" do
      deleted_movie_director =
        movie_director_fixture(%{
          name: @valid_attrs.name,
          deleted_at: DateTime.now!("Etc/UTC")
        })

      assert Repo.aggregate(MovieDirector, :count, :id) == 1

      assert {:ok, %MovieDirector{} = movie_director} = Upsert.call(@valid_attrs)

      assert movie_director.id != deleted_movie_director.id
      assert movie_director.name == @valid_attrs.name
      assert movie_director.deleted_at == nil

      assert Repo.aggregate(MovieDirector, :count, :id) == 2
    end
  end
end

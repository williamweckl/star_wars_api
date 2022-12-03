defmodule StarWars.Interactors.Movie.UpsertTest do
  use StarWars.DataCase

  alias StarWars.Entities.Movie

  alias StarWars.Interactors.Movie.Upsert
  alias StarWars.Repo

  @valid_attrs %{
    title: "A New Hope",
    release_date: ~D[2000-01-01],
    integration_source:
      StarWars.Enums.IntegrationSource.__enum_map__() |> Keyword.keys() |> Enum.random(),
    integration_id: "#{:rand.uniform(999_999_999)}",
    director_id: Ecto.UUID.generate()
  }

  defp movie_fixture(attrs) do
    Factory.insert(:movie, attrs)
  end

  defp assert_has_upserted_movie_attrs(movie) do
    assert_match = fn movie ->
      assert movie.title == @valid_attrs.title
      assert movie.release_date == @valid_attrs.release_date
      assert "#{movie.integration_source}" == "#{@valid_attrs.integration_source}"
      assert movie.integration_id == @valid_attrs.integration_id
      assert movie.director_id == @valid_attrs.director_id
    end

    assert_match.(movie)

    persisted_movie = Repo.reload!(movie)
    assert_match.(persisted_movie)
  end

  describe "call/1" do
    test "creates a movie when movie does not exist yet" do
      _director = Factory.insert(:movie_director, %{id: @valid_attrs.director_id})

      assert Repo.aggregate(Movie, :count, :id) == 0

      assert {:ok, %Movie{} = movie} = Upsert.call(@valid_attrs)

      assert_has_upserted_movie_attrs(movie)

      assert Repo.aggregate(Movie, :count, :id) == 1
    end

    test "creates a movie with not capitalized title attribute" do
      _director = Factory.insert(:movie_director, %{id: @valid_attrs.director_id})

      assert Repo.aggregate(Movie, :count, :id) == 0

      assert {:ok, %Movie{} = movie} =
               @valid_attrs
               |> Map.put(:title, String.downcase(@valid_attrs.title))
               |> Upsert.call()

      assert_has_upserted_movie_attrs(movie)

      assert Repo.aggregate(Movie, :count, :id) == 1
    end

    test "creates a movie with title that contains spaces attribute" do
      _director = Factory.insert(:movie_director, %{id: @valid_attrs.director_id})

      assert Repo.aggregate(Movie, :count, :id) == 0

      assert {:ok, %Movie{} = movie} =
               @valid_attrs |> Map.put(:title, " #{@valid_attrs.title}  ") |> Upsert.call()

      assert_has_upserted_movie_attrs(movie)

      assert Repo.aggregate(Movie, :count, :id) == 1
    end

    test "updates a movie when movie already exists" do
      _director = Factory.insert(:movie_director, %{id: @valid_attrs.director_id})

      movie_fixture(%{
        integration_source: @valid_attrs.integration_source,
        integration_id: @valid_attrs.integration_id
      })

      assert Repo.aggregate(Movie, :count, :id) == 1

      assert {:ok, %Movie{} = movie} = Upsert.call(@valid_attrs)

      assert_has_upserted_movie_attrs(movie)

      assert Repo.aggregate(Movie, :count, :id) == 1
    end

    test "updates a movie when movie already exists with not capitalized title attribute" do
      _director = Factory.insert(:movie_director, %{id: @valid_attrs.director_id})

      movie_fixture(%{
        integration_source: @valid_attrs.integration_source,
        integration_id: @valid_attrs.integration_id
      })

      assert Repo.aggregate(Movie, :count, :id) == 1

      assert {:ok, %Movie{} = movie} =
               @valid_attrs
               |> Map.put(:title, String.downcase(@valid_attrs.title))
               |> Upsert.call()

      assert_has_upserted_movie_attrs(movie)

      assert Repo.aggregate(Movie, :count, :id) == 1
    end

    test "updates a movie when movie already exists with title that contains spaces attribute" do
      _director = Factory.insert(:movie_director, %{id: @valid_attrs.director_id})

      movie_fixture(%{
        integration_source: @valid_attrs.integration_source,
        integration_id: @valid_attrs.integration_id
      })

      assert Repo.aggregate(Movie, :count, :id) == 1

      assert {:ok, %Movie{} = movie} =
               @valid_attrs
               |> Map.put(:title, " #{@valid_attrs.title}  ")
               |> Upsert.call()

      assert_has_upserted_movie_attrs(movie)

      assert Repo.aggregate(Movie, :count, :id) == 1
    end

    test "does not create movie when attrs are invalid" do
      attrs = Map.merge(@valid_attrs, %{release_date: nil})

      assert Repo.aggregate(Movie, :count, :id) == 0

      assert {:error, %Ecto.Changeset{} = changeset} = Upsert.call(attrs)

      assert "can't be blank" in errors_on(changeset).release_date

      assert Repo.aggregate(Movie, :count, :id) == 0
    end

    test "does not update when attrs are invalid" do
      movie =
        movie_fixture(%{
          integration_source: @valid_attrs.integration_source,
          integration_id: @valid_attrs.integration_id
        })

      attrs = Map.merge(@valid_attrs, %{release_date: nil})

      assert {:error, %Ecto.Changeset{} = changeset} = Upsert.call(attrs)

      assert "can't be blank" in errors_on(changeset).release_date

      reloaded_movie = Repo.reload(movie)

      assert reloaded_movie.release_date == movie.release_date
    end

    test "creates a movie when movie with same integration_id exists but was deleted" do
      _director = Factory.insert(:movie_director, %{id: @valid_attrs.director_id})

      deleted_movie =
        movie_fixture(%{
          integration_source: @valid_attrs.integration_source,
          integration_id: @valid_attrs.integration_id,
          deleted_at: DateTime.now!("Etc/UTC")
        })

      assert Repo.aggregate(Movie, :count, :id) == 1

      assert {:ok, %Movie{} = movie} = Upsert.call(@valid_attrs)

      assert movie.id != deleted_movie.id
      assert movie.title == @valid_attrs.title
      assert movie.deleted_at == nil

      assert Repo.aggregate(Movie, :count, :id) == 2
    end
  end
end

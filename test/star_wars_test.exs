defmodule StarWarsTest do
  use StarWars.DataCase
  import Mock

  alias CleanArchitecture.Pagination

  alias Ecto.Changeset
  alias StarWars.Contracts
  alias StarWars.Interactors

  alias StarWars.Entities.Climate
  alias StarWars.Entities.Movie
  alias StarWars.Entities.MovieDirector
  alias StarWars.Entities.Planet
  alias StarWars.Entities.Terrain

  # Climate

  describe "upsert_climate/1" do
    test "calls right interactor and handles :ok output" do
      with_mocks([
        {Interactors.Climate.Upsert, [], [call: fn _input -> {:ok, %Climate{}} end]},
        {Contracts.Climate.Upsert, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert {:ok, %Climate{}} == StarWars.upsert_climate(input)

        assert_called_exactly(Interactors.Climate.Upsert.call(input), 1)
      end
    end

    test "calls right interactor and handles :error output" do
      with_mocks([
        {Interactors.Climate.Upsert, [], [call: fn _input -> {:error, %Changeset{}} end]},
        {Contracts.Climate.Upsert, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert {:error, %Changeset{}} == StarWars.upsert_climate(input)

        assert_called_exactly(Interactors.Climate.Upsert.call(input), 1)
      end
    end

    test "calls right interactor and raises when output is not handled" do
      with_mocks([
        {Interactors.Climate.Upsert, [], [call: fn _input -> %Climate{} end]},
        {Contracts.Climate.Upsert, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert_raise WithClauseError, fn ->
          StarWars.upsert_climate(input)
        end

        assert_called_exactly(Interactors.Climate.Upsert.call(input), 1)
      end
    end
  end

  # Terrain

  describe "upsert_terrain/1" do
    test "calls right interactor and handles :ok output" do
      with_mocks([
        {Interactors.Terrain.Upsert, [], [call: fn _input -> {:ok, %Terrain{}} end]},
        {Contracts.Terrain.Upsert, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert {:ok, %Terrain{}} == StarWars.upsert_terrain(input)

        assert_called_exactly(Interactors.Terrain.Upsert.call(input), 1)
      end
    end

    test "calls right interactor and handles :error output" do
      with_mocks([
        {Interactors.Terrain.Upsert, [], [call: fn _input -> {:error, %Changeset{}} end]},
        {Contracts.Terrain.Upsert, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert {:error, %Changeset{}} == StarWars.upsert_terrain(input)

        assert_called_exactly(Interactors.Terrain.Upsert.call(input), 1)
      end
    end

    test "calls right interactor and raises when output is not handled" do
      with_mocks([
        {Interactors.Terrain.Upsert, [], [call: fn _input -> %Terrain{} end]},
        {Contracts.Terrain.Upsert, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert_raise WithClauseError, fn ->
          StarWars.upsert_terrain(input)
        end

        assert_called_exactly(Interactors.Terrain.Upsert.call(input), 1)
      end
    end
  end

  # Movie Director

  describe "upsert_movie_director/1" do
    test "calls right interactor and handles :ok output" do
      with_mocks([
        {Interactors.MovieDirector.Upsert, [], [call: fn _input -> {:ok, %MovieDirector{}} end]},
        {Contracts.MovieDirector.Upsert, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert {:ok, %MovieDirector{}} == StarWars.upsert_movie_director(input)

        assert_called_exactly(Interactors.MovieDirector.Upsert.call(input), 1)
      end
    end

    test "calls right interactor and handles :error output" do
      with_mocks([
        {Interactors.MovieDirector.Upsert, [], [call: fn _input -> {:error, %Changeset{}} end]},
        {Contracts.MovieDirector.Upsert, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert {:error, %Changeset{}} == StarWars.upsert_movie_director(input)

        assert_called_exactly(Interactors.MovieDirector.Upsert.call(input), 1)
      end
    end

    test "calls right interactor and raises when output is not handled" do
      with_mocks([
        {Interactors.MovieDirector.Upsert, [], [call: fn _input -> %MovieDirector{} end]},
        {Contracts.MovieDirector.Upsert, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert_raise WithClauseError, fn ->
          StarWars.upsert_movie_director(input)
        end

        assert_called_exactly(Interactors.MovieDirector.Upsert.call(input), 1)
      end
    end
  end

  # Movie

  describe "list_movies/1" do
    test "calls right interactor and handles output for empty list" do
      pagination = %Pagination{
        entries: [],
        page_number: 1,
        page_size: 1,
        total_entries: 0,
        total_pages: 1
      }

      with_mocks([
        {Interactors.Movie.List, [], [call: fn _input -> pagination end]},
        {Contracts.Movie.List, [], [validate_input: fn attrs -> {:ok, attrs} end]}
      ]) do
        input = %{name: ""}
        assert pagination == StarWars.list_movies(input)

        assert_called_exactly(Interactors.Movie.List.call(input), 1)
        assert_called_exactly(Contracts.Movie.List.validate_input(input), 1)
      end
    end

    test "calls right interactor and handles output for non empty list" do
      pagination = %Pagination{
        entries: [%Movie{}],
        page_number: 1,
        page_size: 1,
        total_entries: 1,
        total_pages: 1
      }

      with_mocks([
        {Interactors.Movie.List, [], [call: fn _input -> pagination end]},
        {Contracts.Movie.List, [], [validate_input: fn attrs -> {:ok, attrs} end]}
      ]) do
        input = %{name: ""}
        assert pagination == StarWars.list_movies(input)

        assert_called_exactly(Interactors.Movie.List.call(input), 1)
        assert_called_exactly(Contracts.Movie.List.validate_input(input), 1)
      end
    end

    test "calls right interactor and raises when output is not a pagination" do
      not_pagination_output = %{
        entries: [%Movie{}],
        page_number: 1,
        page_size: 1,
        total_entries: 1,
        total_pages: 1
      }

      with_mocks([
        {Interactors.Movie.List, [], [call: fn _input -> not_pagination_output end]},
        {Contracts.Movie.List, [], [validate_input: fn attrs -> {:ok, attrs} end]}
      ]) do
        input = %{name: ""}

        assert_raise MatchError, fn ->
          StarWars.list_movies(input)
        end

        assert_called_exactly(Interactors.Movie.List.call(input), 1)
        assert_called_exactly(Contracts.Movie.List.validate_input(input), 1)
      end
    end

    test "calls right interactor and handles invalid input" do
      with_mocks([
        {Interactors.Movie.List, [], [call: fn _input -> :ok end]},
        {Contracts.Movie.List, [], [validate_input: fn _attrs -> {:error, %Ecto.Changeset{}} end]}
      ]) do
        input = %{name: ""}

        assert {:error, %Ecto.Changeset{}} ==
                 StarWars.list_movies(input)

        assert_not_called(Interactors.Movie.List.call(input))
        assert_called_exactly(Contracts.Movie.List.validate_input(input), 1)
      end
    end
  end

  describe "get_movie!/1" do
    test "calls right interactor and handles output for Movie struct" do
      with_mocks([
        {Interactors.Movie.Get, [], [call: fn _input -> %Movie{} end]},
        {Contracts.Movie.Get, [], [validate_input: fn attrs -> {:ok, attrs} end]}
      ]) do
        input = %{id: ""}
        assert %Movie{} == StarWars.get_movie!(input)

        assert_called_exactly(Interactors.Movie.Get.call(input), 1)
        assert_called_exactly(Contracts.Movie.Get.validate_input(input), 1)
      end
    end

    test "calls right interactor and raises when output is not a Movie struct" do
      with_mocks([
        {Interactors.Movie.Get, [], [call: fn _input -> "string" end]},
        {Contracts.Movie.Get, [], [validate_input: fn attrs -> {:ok, attrs} end]}
      ]) do
        input = %{id: ""}

        assert_raise MatchError, fn ->
          StarWars.get_movie!(input)
        end

        assert_called_exactly(Interactors.Movie.Get.call(input), 1)
        assert_called_exactly(Contracts.Movie.Get.validate_input(input), 1)
      end
    end

    test "calls right interactor and handles invalid input" do
      with_mocks([
        {Interactors.Movie.Get, [], [call: fn _input -> %Movie{} end]},
        {Contracts.Movie.Get, [], [validate_input: fn _attrs -> {:error, %Ecto.Changeset{}} end]}
      ]) do
        input = %{id: ""}

        assert {:error, %Ecto.Changeset{}} ==
                 StarWars.get_movie!(input)

        assert_not_called(Interactors.Movie.Get.call(input))
        assert_called_exactly(Contracts.Movie.Get.validate_input(input), 1)
      end
    end
  end

  describe "upsert_movie/1" do
    test "calls right interactor and handles :ok output" do
      with_mocks([
        {Interactors.Movie.Upsert, [], [call: fn _input -> {:ok, %Movie{}} end]},
        {Contracts.Movie.Upsert, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert {:ok, %Movie{}} == StarWars.upsert_movie(input)

        assert_called_exactly(Interactors.Movie.Upsert.call(input), 1)
      end
    end

    test "calls right interactor and handles :error output" do
      with_mocks([
        {Interactors.Movie.Upsert, [], [call: fn _input -> {:error, %Changeset{}} end]},
        {Contracts.Movie.Upsert, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert {:error, %Changeset{}} == StarWars.upsert_movie(input)

        assert_called_exactly(Interactors.Movie.Upsert.call(input), 1)
      end
    end

    test "calls right interactor and raises when output is not handled" do
      with_mocks([
        {Interactors.Movie.Upsert, [], [call: fn _input -> %Movie{} end]},
        {Contracts.Movie.Upsert, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert_raise WithClauseError, fn ->
          StarWars.upsert_movie(input)
        end

        assert_called_exactly(Interactors.Movie.Upsert.call(input), 1)
      end
    end
  end

  # Planet

  describe "list_planets/1" do
    test "calls right interactor and handles output for empty list" do
      pagination = %Pagination{
        entries: [],
        page_number: 1,
        page_size: 1,
        total_entries: 0,
        total_pages: 1
      }

      with_mocks([
        {Interactors.Planet.List, [], [call: fn _input -> pagination end]},
        {Contracts.Planet.List, [], [validate_input: fn attrs -> {:ok, attrs} end]}
      ]) do
        input = %{name: ""}
        assert pagination == StarWars.list_planets(input)

        assert_called_exactly(Interactors.Planet.List.call(input), 1)
        assert_called_exactly(Contracts.Planet.List.validate_input(input), 1)
      end
    end

    test "calls right interactor and handles output for non empty list" do
      pagination = %Pagination{
        entries: [%Planet{}],
        page_number: 1,
        page_size: 1,
        total_entries: 1,
        total_pages: 1
      }

      with_mocks([
        {Interactors.Planet.List, [], [call: fn _input -> pagination end]},
        {Contracts.Planet.List, [], [validate_input: fn attrs -> {:ok, attrs} end]}
      ]) do
        input = %{name: ""}
        assert pagination == StarWars.list_planets(input)

        assert_called_exactly(Interactors.Planet.List.call(input), 1)
        assert_called_exactly(Contracts.Planet.List.validate_input(input), 1)
      end
    end

    test "calls right interactor and raises when output is not a pagination" do
      not_pagination_output = %{
        entries: [%Planet{}],
        page_number: 1,
        page_size: 1,
        total_entries: 1,
        total_pages: 1
      }

      with_mocks([
        {Interactors.Planet.List, [], [call: fn _input -> not_pagination_output end]},
        {Contracts.Planet.List, [], [validate_input: fn attrs -> {:ok, attrs} end]}
      ]) do
        input = %{name: ""}

        assert_raise MatchError, fn ->
          StarWars.list_planets(input)
        end

        assert_called_exactly(Interactors.Planet.List.call(input), 1)
        assert_called_exactly(Contracts.Planet.List.validate_input(input), 1)
      end
    end

    test "calls right interactor and handles invalid input" do
      with_mocks([
        {Interactors.Planet.List, [], [call: fn _input -> :ok end]},
        {Contracts.Planet.List, [],
         [validate_input: fn _attrs -> {:error, %Ecto.Changeset{}} end]}
      ]) do
        input = %{name: ""}

        assert {:error, %Ecto.Changeset{}} ==
                 StarWars.list_planets(input)

        assert_not_called(Interactors.Planet.List.call(input))
        assert_called_exactly(Contracts.Planet.List.validate_input(input), 1)
      end
    end
  end

  describe "get_planet!/1" do
    test "calls right interactor and handles output for Planet struct" do
      with_mocks([
        {Interactors.Planet.Get, [], [call: fn _input -> %Planet{} end]},
        {Contracts.Planet.Get, [], [validate_input: fn attrs -> {:ok, attrs} end]}
      ]) do
        input = %{id: ""}
        assert %Planet{} == StarWars.get_planet!(input)

        assert_called_exactly(Interactors.Planet.Get.call(input), 1)
        assert_called_exactly(Contracts.Planet.Get.validate_input(input), 1)
      end
    end

    test "calls right interactor and raises when output is not a Planet struct" do
      with_mocks([
        {Interactors.Planet.Get, [], [call: fn _input -> "string" end]},
        {Contracts.Planet.Get, [], [validate_input: fn attrs -> {:ok, attrs} end]}
      ]) do
        input = %{id: ""}

        assert_raise MatchError, fn ->
          StarWars.get_planet!(input)
        end

        assert_called_exactly(Interactors.Planet.Get.call(input), 1)
        assert_called_exactly(Contracts.Planet.Get.validate_input(input), 1)
      end
    end

    test "calls right interactor and handles invalid input" do
      with_mocks([
        {Interactors.Planet.Get, [], [call: fn _input -> %Planet{} end]},
        {Contracts.Planet.Get, [], [validate_input: fn _attrs -> {:error, %Ecto.Changeset{}} end]}
      ]) do
        input = %{id: ""}

        assert {:error, %Ecto.Changeset{}} ==
                 StarWars.get_planet!(input)

        assert_not_called(Interactors.Planet.Get.call(input))
        assert_called_exactly(Contracts.Planet.Get.validate_input(input), 1)
      end
    end
  end

  describe "upsert_planet/1" do
    test "calls right interactor and handles :ok output" do
      with_mocks([
        {Interactors.Planet.Upsert, [], [call: fn _input -> {:ok, %Planet{}} end]},
        {Contracts.Planet.Upsert, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert {:ok, %Planet{}} == StarWars.upsert_planet(input)

        assert_called_exactly(Interactors.Planet.Upsert.call(input), 1)
      end
    end

    test "calls right interactor and handles :error output" do
      with_mocks([
        {Interactors.Planet.Upsert, [], [call: fn _input -> {:error, %Changeset{}} end]},
        {Contracts.Planet.Upsert, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert {:error, %Changeset{}} == StarWars.upsert_planet(input)

        assert_called_exactly(Interactors.Planet.Upsert.call(input), 1)
      end
    end

    test "calls right interactor and raises when output is not handled" do
      with_mocks([
        {Interactors.Planet.Upsert, [], [call: fn _input -> %Planet{} end]},
        {Contracts.Planet.Upsert, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert_raise WithClauseError, fn ->
          StarWars.upsert_planet(input)
        end

        assert_called_exactly(Interactors.Planet.Upsert.call(input), 1)
      end
    end
  end

  describe "load_planet_from_integration/1" do
    test "calls right interactor and handles :ok output" do
      with_mocks([
        {Interactors.Planet.LoadFromIntegration, [], [call: fn _input -> {:ok, %Planet{}} end]},
        {Contracts.Planet.LoadFromIntegration, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert {:ok, %Planet{}} == StarWars.load_planet_from_integration(input)

        assert_called_exactly(Interactors.Planet.LoadFromIntegration.call(input), 1)
      end
    end

    test "calls right interactor and handles :error output" do
      with_mocks([
        {Interactors.Planet.LoadFromIntegration, [],
         [call: fn _input -> {:error, %Changeset{}} end]},
        {Contracts.Planet.LoadFromIntegration, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert {:error, %Changeset{}} == StarWars.load_planet_from_integration(input)

        assert_called_exactly(Interactors.Planet.LoadFromIntegration.call(input), 1)
      end
    end

    test "calls right interactor and handles not changeset :error output" do
      with_mocks([
        {Interactors.Planet.LoadFromIntegration, [],
         [call: fn _input -> {:error, :invalid_response} end]},
        {Contracts.Planet.LoadFromIntegration, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert {:error, :invalid_response} == StarWars.load_planet_from_integration(input)

        assert_called_exactly(Interactors.Planet.LoadFromIntegration.call(input), 1)
      end
    end

    test "calls right interactor and raises when output is not handled" do
      with_mocks([
        {Interactors.Planet.LoadFromIntegration, [], [call: fn _input -> %Planet{} end]},
        {Contracts.Planet.LoadFromIntegration, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert_raise WithClauseError, fn ->
          StarWars.load_planet_from_integration(input)
        end

        assert_called_exactly(Interactors.Planet.LoadFromIntegration.call(input), 1)
      end
    end
  end

  describe "delete_planet/1" do
    test "calls right interactor and handles :ok output" do
      with_mocks([
        {Interactors.Planet.Delete, [], [call: fn _input -> {:ok, %Planet{}} end]},
        {Contracts.Planet.Delete, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert {:ok, %Planet{}} == StarWars.delete_planet(input)

        assert_called_exactly(Interactors.Planet.Delete.call(input), 1)
      end
    end

    test "calls right interactor and handles :error output" do
      with_mocks([
        {Interactors.Planet.Delete, [], [call: fn _input -> {:error, %Changeset{}} end]},
        {Contracts.Planet.Delete, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert {:error, %Changeset{}} == StarWars.delete_planet(input)

        assert_called_exactly(Interactors.Planet.Delete.call(input), 1)
      end
    end

    test "calls right interactor and raises when output is not handled" do
      with_mocks([
        {Interactors.Planet.Delete, [], [call: fn _input -> %Planet{} end]},
        {Contracts.Planet.Delete, [], [validate_input: &{:ok, &1}]}
      ]) do
        input = %{
          id: ""
        }

        assert_raise WithClauseError, fn ->
          StarWars.delete_planet(input)
        end

        assert_called_exactly(Interactors.Planet.Delete.call(input), 1)
      end
    end
  end
end

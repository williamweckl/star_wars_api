defmodule StarWarsTest do
  use StarWars.DataCase
  import Mock

  alias Ecto.Changeset
  alias StarWars.Contracts
  alias StarWars.Interactors

  alias StarWars.Entities.Climate
  alias StarWars.Entities.MovieDirector

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
end

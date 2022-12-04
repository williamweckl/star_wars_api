defmodule StarWars.Interactors.Movie.ListTest do
  use StarWars.DataCase
  import StarWars.Support.QueryPagination

  alias StarWars.Interactors.Movie.List

  def fixture(attrs \\ %{}) do
    Factory.insert(:movie, attrs)
  end

  describe "call/1" do
    test "returns all movies" do
      input = %{page: 1, page_size: 10}

      one = fixture()
      two = fixture()
      records = List.call(input).entries

      ids = Enum.map(records, & &1.id)
      assert Enum.sort(ids) == Enum.sort([one.id, two.id])
    end

    test "paginates results" do
      records = Factory.insert_list(3, :movie)

      records =
        records
        |> Repo.reload!()
        |> Repo.preload([:director])
        |> Enum.sort_by(& &1.inserted_at)
        |> Enum.reverse()

      default_input = %{page: 1, page_size: 10}
      assert_paginate_query(List, :call, default_input, records)
    end

    test "excludes deleted movies from result entries" do
      one = fixture()
      two = fixture()
      _deleted_one = fixture(%{deleted_at: DateTime.now!("Etc/UTC")})
      _deleted_two = fixture(%{deleted_at: DateTime.now!("Etc/UTC")})

      input = %{page: 1, page_size: 10}

      records = List.call(input).entries
      ids = Enum.map(records, & &1.id)
      assert Enum.sort(ids) == Enum.sort([one.id, two.id])
    end

    test "filters by title" do
      one = fixture(%{title: "A New Hope"})
      two = fixture(%{title: "Return Of The Jedi"})

      input = %{title: "A New Hope", page: 1, page_size: 10}
      records = List.call(input).entries
      assert length(records) == 1
      assert Enum.at(records, 0).id == one.id

      input = %{title: "A New", page: 1, page_size: 10}
      records = List.call(input).entries
      assert length(records) == 1
      assert Enum.at(records, 0).id == one.id

      input = %{title: "a new", page: 1, page_size: 10}
      records = List.call(input).entries
      assert length(records) == 1
      assert Enum.at(records, 0).id == one.id

      input = %{title: "Return Of The Jedi", page: 1, page_size: 10}
      records = List.call(input).entries
      assert length(records) == 1
      assert Enum.at(records, 0).id == two.id

      input = %{title: "Return Of", page: 1, page_size: 10}
      records = List.call(input).entries
      assert length(records) == 1
      assert Enum.at(records, 0).id == two.id

      input = %{title: "return", page: 1, page_size: 10}
      records = List.call(input).entries
      assert length(records) == 1
      assert Enum.at(records, 0).id == two.id

      input = %{title: "invalid", page: 1, page_size: 10}
      records = List.call(input).entries
      assert Enum.empty?(records)
    end

    test "orders by inserted_at desc" do
      first_record = fixture()
      second_record = fixture()
      third_record = fixture()

      input = %{page: 1, page_size: 10}

      records = List.call(input).entries
      ids = Enum.map(records, & &1.id)

      assert Enum.at(ids, 0) == third_record.id
      assert Enum.at(ids, 1) == second_record.id
      assert Enum.at(ids, 2) == first_record.id
    end
  end
end

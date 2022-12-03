defmodule StarWars.Interactors.Planet.ListTest do
  use StarWars.DataCase
  import StarWars.Support.QueryPagination

  alias StarWars.Interactors.Planet.List

  def fixture(attrs \\ %{}) do
    Factory.insert(:planet, attrs)
  end

  describe "call/1" do
    test "returns all planets" do
      input = %{page: 1, page_size: 10}

      one = fixture()
      two = fixture()
      records = List.call(input).entries

      ids = Enum.map(records, & &1.id)
      assert Enum.sort(ids) == Enum.sort([one.id, two.id])
    end

    test "paginates results" do
      records = Factory.insert_list(3, :planet)
      records = records |> Repo.reload!() |> Enum.sort_by(& &1.inserted_at) |> Enum.reverse()

      default_input = %{page: 1, page_size: 10}
      assert_paginate_query(List, :call, default_input, records)
    end

    test "excludes deleted planets from result entries" do
      one = fixture()
      two = fixture()
      _deleted_one = fixture(%{deleted_at: DateTime.now!("Etc/UTC")})
      _deleted_two = fixture(%{deleted_at: DateTime.now!("Etc/UTC")})

      input = %{page: 1, page_size: 10}

      records = List.call(input).entries
      ids = Enum.map(records, & &1.id)
      assert Enum.sort(ids) == Enum.sort([one.id, two.id])
    end

    test "filters by name" do
      one = fixture(%{name: "Tatooine"})
      two = fixture(%{name: "Alderaan"})

      input = %{name: "Tatooine", page: 1, page_size: 10}
      records = List.call(input).entries
      assert length(records) == 1
      assert Enum.at(records, 0).id == one.id

      input = %{name: "Tat", page: 1, page_size: 10}
      records = List.call(input).entries
      assert length(records) == 1
      assert Enum.at(records, 0).id == one.id

      input = %{name: "Tatoo", page: 1, page_size: 10}
      records = List.call(input).entries
      assert length(records) == 1
      assert Enum.at(records, 0).id == one.id

      input = %{name: "tatoo", page: 1, page_size: 10}
      records = List.call(input).entries
      assert length(records) == 1
      assert Enum.at(records, 0).id == one.id

      input = %{name: "Alderaan", page: 1, page_size: 10}
      records = List.call(input).entries
      assert length(records) == 1
      assert Enum.at(records, 0).id == two.id

      input = %{name: "Ald", page: 1, page_size: 10}
      records = List.call(input).entries
      assert length(records) == 1
      assert Enum.at(records, 0).id == two.id

      input = %{name: "ald", page: 1, page_size: 10}
      records = List.call(input).entries
      assert length(records) == 1
      assert Enum.at(records, 0).id == two.id

      input = %{name: "invalid", page: 1, page_size: 10}
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

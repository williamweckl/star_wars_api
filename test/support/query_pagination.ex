defmodule StarWars.Support.QueryPagination do
  @moduledoc """
  Query Pagination test helpers.
  """

  import ExUnit.Assertions

  alias CleanArchitecture.Pagination

  def assert_paginate_query(module_name, function_name, default_input, records) do
    total_entries = Enum.count(records)

    response = apply(module_name, function_name, [default_input])

    assert response ==
             %Pagination{
               entries: records,
               page_number: default_input.page,
               page_size: default_input.page_size,
               total_entries: total_entries,
               total_pages: Float.ceil(total_entries / default_input.page_size)
             }

    input = %{default_input | page: 2, page_size: 1}
    response = apply(module_name, function_name, [input])

    assert response ==
             %Pagination{
               entries: [Enum.at(records, 1)],
               page_number: 2,
               page_size: 1,
               total_entries: total_entries,
               total_pages: total_entries
             }

    input = %{default_input | page: 3, page_size: 1}
    response = apply(module_name, function_name, [input])

    assert response ==
             %Pagination{
               entries: [Enum.at(records, 2)],
               page_number: 3,
               page_size: 1,
               total_entries: total_entries,
               total_pages: total_entries
             }

    input = %{default_input | page: 999, page_size: 1}
    response = apply(module_name, function_name, [input])

    assert response ==
             %Pagination{
               entries: [],
               page_number: 999,
               page_size: 1,
               total_entries: total_entries,
               total_pages: total_entries
             }

    input = %{default_input | page: 1, page_size: 2}
    response = apply(module_name, function_name, [input])

    assert response ==
             %Pagination{
               entries: [Enum.at(records, 0), Enum.at(records, 1)],
               page_number: 1,
               page_size: 2,
               total_entries: total_entries,
               total_pages: Float.ceil(total_entries / 2)
             }
  end
end

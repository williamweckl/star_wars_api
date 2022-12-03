defmodule StarWars.Contracts.Planet.ListTest do
  use StarWars.DataCase

  alias StarWars.Contracts.Planet.List

  @valid_attrs %{
    name: "Valid name"
  }

  describe "changeset" do
    test "creates valid changeset when all parameters are valid" do
      changeset = List.changeset(@valid_attrs)

      assert changeset.valid?
      assert changeset.changes == Map.merge(@valid_attrs, %{page: 1, page_size: 10})
    end

    test "returns error when changeset is missing any required field" do
      changeset = List.changeset(%{})

      assert Enum.sort(changeset.errors) == []
    end

    test "does not return error when page is above zero" do
      attrs = Map.put(@valid_attrs, :page, 1)
      changeset = List.changeset(attrs)

      refute errors_on(changeset)[:page]
    end

    test "returns error when page is zero" do
      attrs = Map.put(@valid_attrs, :page, 0)
      changeset = List.changeset(attrs)

      assert "must be greater than or equal to 1" in errors_on(changeset).page
    end

    test "returns error when page is negative" do
      attrs = Map.put(@valid_attrs, :page, -1)
      changeset = List.changeset(attrs)

      assert "must be greater than or equal to 1" in errors_on(changeset).page
    end

    test "does not return error when page_size is above zero" do
      attrs = Map.put(@valid_attrs, :page_size, 1)
      changeset = List.changeset(attrs)

      refute errors_on(changeset)[:page_size]
    end

    test "returns error when page_size is zero" do
      attrs = Map.put(@valid_attrs, :page_size, 0)
      changeset = List.changeset(attrs)

      assert "must be greater than or equal to 1" in errors_on(changeset).page_size
    end

    test "does not return error when page_size is 100" do
      attrs = Map.put(@valid_attrs, :page_size, 100)
      changeset = List.changeset(attrs)

      refute errors_on(changeset)[:page_size]
    end

    test "returns error when page_size is negative" do
      attrs = Map.put(@valid_attrs, :page_size, -1)
      changeset = List.changeset(attrs)

      assert "must be greater than or equal to 1" in errors_on(changeset).page_size
    end

    test "returns error when page_size is above 100" do
      attrs = Map.put(@valid_attrs, :page_size, 101)
      changeset = List.changeset(attrs)

      assert "must be less than or equal to 100" in errors_on(changeset).page_size
    end
  end
end

defmodule StarWars.Interactors.Terrain.Upsert do
  @moduledoc """
  Terrain upsert use case.
  Do not call this module directly, use always the StarWars module that is the boundary context.

  ## General rules:

  - When a terrain with the given `id` already exist, it will be updated.
  - When a terrain with the given `id` does not exist, it will be created.
  """

  use CleanArchitecture.Interactor

  alias StarWars.Entities.Terrain
  alias StarWars.Repo

  @doc """
  Upserts a terrain.
  """
  def call(%{id: _id} = input) do
    input
    |> normalize_id()
    |> get_existent_terrain()
    |> upsert_terrain()
    |> handle_output()
  end

  defp normalize_id(%{id: id} = input) do
    normalized_id =
      id
      |> String.trim()
      |> String.downcase()
      |> String.replace(" ", "_")

    input
    |> Map.put(:id, normalized_id)
  end

  defp get_existent_terrain(%{id: id} = input) do
    existent_terrain = Terrain |> Repo.get_by(id: id)

    input |> Map.put(:existent_terrain, existent_terrain)
  end

  defp upsert_terrain(%{existent_terrain: nil} = input) do
    input
    |> Terrain.changeset()
    |> Repo.insert()
  end

  defp upsert_terrain(%{existent_terrain: %Terrain{} = existent_terrain} = input) do
    existent_terrain
    |> Terrain.changeset(input)
    |> Repo.update()
  end

  defp handle_output({:ok, %Terrain{} = terrain}), do: {:ok, terrain}
  defp handle_output({:error, %Ecto.Changeset{} = changeset}), do: {:error, changeset}
end

defmodule StarWars.Interactors.Planet.Upsert do
  @moduledoc """
  Planet upsert use case.
  Do not call this module directly, use always the StarWars module that is the boundary context.

  ## General rules:

  - When a planet with the given `integration_source` and `integration_id` already exist and is not deleted, it will be updated.
  - When a planet with the given `integration_source` and `integration_id` does not exist, it will be created.
  """

  use CleanArchitecture.Interactor

  alias StarWars.Entities.Planet
  alias StarWars.Repo

  @doc """
  Upserts a planet.
  """
  def call(%{integration_source: _integration_source, integration_id: _integration_id} = input) do
    input
    |> normalize_name()
    |> get_existent_planet()
    |> upsert_planet()
    |> preload_associations()
    |> handle_output()
  end

  defp normalize_name(%{name: name} = input) do
    normalized_name =
      name
      |> String.trim()
      |> String.split(" ")
      |> Enum.map_join(" ", &String.capitalize/1)

    input
    |> Map.put(:name, normalized_name)
  end

  defp get_existent_planet(
         %{integration_source: integration_source, integration_id: integration_id} = input
       ) do
    existent_planet =
      Planet
      |> where([t], is_nil(t.deleted_at))
      |> Repo.get_by(integration_source: integration_source, integration_id: integration_id)

    input |> Map.put(:existent_planet, existent_planet)
  end

  defp upsert_planet(
         %{existent_planet: nil, climates: climates, terrains: terrains, movies: movies} = input
       ) do
    input
    |> Planet.changeset()
    |> Ecto.Changeset.put_assoc(:climates, climates)
    |> Ecto.Changeset.put_assoc(:terrains, terrains)
    |> Ecto.Changeset.put_assoc(:movies, movies)
    |> Repo.insert()
  end

  defp upsert_planet(
         %{
           existent_planet: existent_planet,
           climates: climates,
           terrains: terrains,
           movies: movies
         } = input
       ) do
    existent_planet
    |> preload_associations!()
    |> Planet.changeset(input)
    |> Ecto.Changeset.put_assoc(:climates, climates)
    |> Ecto.Changeset.put_assoc(:terrains, terrains)
    |> Ecto.Changeset.put_assoc(:movies, movies)
    |> Repo.update()
  end

  defp preload_associations({:ok, %Planet{} = planet}) do
    {:ok, preload_associations!(planet)}
  end

  defp preload_associations(error_response), do: error_response

  defp preload_associations!(%Planet{} = planet) do
    Repo.preload(planet, [:climates, :terrains, :movies])
  end

  defp handle_output({:ok, %Planet{} = planet}), do: {:ok, planet}
  defp handle_output({:error, changeset}), do: {:error, changeset}
end

defmodule StarWars.Interactors.Climate.Upsert do
  @moduledoc """
  Climate upsert use case.
  Do not call this module directly, use always the StarWars module that is the boundary context.

  ## General rules:

  - When a climate with the given `id` already exist, it will be updated.
  - When a climate with the given `id` does not exist, it will be created.
  """

  use CleanArchitecture.Interactor

  alias StarWars.Entities.Climate
  alias StarWars.Repo

  @doc """
  Upserts a climate.
  """
  def call(%{id: _id} = input) do
    input
    |> normalize_id()
    |> get_existent_climate()
    |> upsert_climate()
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

  defp get_existent_climate(%{id: id} = input) do
    existent_climate = Climate |> Repo.get_by(id: id)

    input |> Map.put(:existent_climate, existent_climate)
  end

  defp upsert_climate(%{existent_climate: nil} = input) do
    input
    |> Climate.changeset()
    |> Repo.insert()
  end

  defp upsert_climate(%{existent_climate: %Climate{} = existent_climate} = input) do
    existent_climate
    |> Climate.changeset(input)
    |> Repo.update()
  end

  defp handle_output({:ok, %Climate{} = climate}), do: {:ok, climate}
  defp handle_output({:error, %Ecto.Changeset{} = changeset}), do: {:error, changeset}
end

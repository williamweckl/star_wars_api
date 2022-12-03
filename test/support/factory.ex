defmodule StarWarsAPI.Support.Factory do
  @moduledoc """
  Factory used to create entities for tests.
  """

  # with Ecto
  use ExMachina.Ecto, repo: StarWarsAPI.Repo

  alias StarWarsAPI.Entities.Climate
  alias StarWarsAPI.Entities.MovieDirector
  alias StarWarsAPI.Entities.Terrain

  def climate_factory do
    name = sequence(:name, &"Climate #{&1}")

    %Climate{
      id: name |> String.replace(" ", "_") |> String.downcase(),
      name: name,
      integration_source:
        StarWarsAPI.Enums.IntegrationSource.__enum_map__() |> Keyword.keys() |> Enum.random(),
      deleted_at: nil
    }
  end

  def terrain_factory do
    name = sequence(:name, &"Terrain #{&1}")

    %Terrain{
      id: name |> String.replace(" ", "_") |> String.downcase(),
      name: name,
      integration_source:
        StarWarsAPI.Enums.IntegrationSource.__enum_map__() |> Keyword.keys() |> Enum.random(),
      deleted_at: nil
    }
  end

  def movie_director_factory do
    name = sequence(:name, &"Director #{&1}")

    %MovieDirector{
      name: name,
      integration_source:
        StarWarsAPI.Enums.IntegrationSource.__enum_map__() |> Keyword.keys() |> Enum.random(),
      deleted_at: nil
    }
  end
end

defmodule StarWars.Support.Factory do
  @moduledoc """
  Factory used to create entities for tests.
  """

  # with Ecto
  use ExMachina.Ecto, repo: StarWars.Repo

  alias StarWars.Entities.Climate
  alias StarWars.Entities.Movie
  alias StarWars.Entities.MovieDirector
  alias StarWars.Entities.Planet
  alias StarWars.Entities.Terrain

  alias StarWars.Enums

  def climate_factory do
    name = sequence(:name, &"Climate #{&1}")

    %Climate{
      id: name |> String.replace(" ", "_") |> String.downcase(),
      name: name,
      integration_source:
        Enums.IntegrationSource.__enum_map__() |> Keyword.keys() |> Enum.random(),
      deleted_at: nil
    }
  end

  def terrain_factory do
    name = sequence(:name, &"Terrain #{&1}")

    %Terrain{
      id: name |> String.replace(" ", "_") |> String.downcase(),
      name: name,
      integration_source:
        Enums.IntegrationSource.__enum_map__() |> Keyword.keys() |> Enum.random(),
      deleted_at: nil
    }
  end

  def movie_director_factory do
    name = sequence(:name, &"Director #{&1}")

    %MovieDirector{
      name: name,
      integration_source:
        Enums.IntegrationSource.__enum_map__() |> Keyword.keys() |> Enum.random(),
      deleted_at: nil
    }
  end

  def movie_factory do
    title = sequence(:title, &"Movie #{&1}")

    %Movie{
      title: title,
      release_date: Date.utc_today(),
      integration_source:
        Enums.IntegrationSource.__enum_map__() |> Keyword.keys() |> Enum.random(),
      integration_id: "#{:rand.uniform(999_999_999)}",
      director: build(:movie_director),
      deleted_at: nil
    }
  end

  def planet_factory do
    name = sequence(:name, &"Planet #{&1}")

    %Planet{
      name: name,
      integration_source:
        Enums.IntegrationSource.__enum_map__() |> Keyword.keys() |> Enum.random(),
      integration_id: "#{:rand.uniform(999_999_999)}",
      deleted_at: nil
    }
  end
end

defmodule StarWarsAPI.Support.Factory do
  @moduledoc """
  Factory used to create entities for tests.
  """

  # with Ecto
  use ExMachina.Ecto, repo: StarWarsAPI.Repo

  alias StarWarsAPI.Entities.Climate

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
end

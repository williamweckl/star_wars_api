defmodule StarWars.Repo.Migrations.CreateIntegrationSourcesEnum do
  use Ecto.Migration

  def up do
    execute("create type integration_source as enum ('star_wars_public_api')")
  end

  def down do
    execute("drop type integration_source")
  end
end

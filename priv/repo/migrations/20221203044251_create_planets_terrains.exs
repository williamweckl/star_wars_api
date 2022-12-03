defmodule StarWars.Repo.Migrations.CreatePlanetsTerrains do
  use Ecto.Migration

  def change do
    create table(:planets_terrains, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")

      add :planet_id, references(:planets, type: :uuid), null: false
      add :terrain_id, references(:terrains, type: :string), null: false
    end

    create unique_index(:planets_terrains, [:planet_id, :terrain_id],
             name: "unique_planets_terrains"
           )
  end
end

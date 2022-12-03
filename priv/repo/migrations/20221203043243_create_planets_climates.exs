defmodule StarWarsAPI.Repo.Migrations.CreatePlanetsClimates do
  use Ecto.Migration

  def change do
    create table(:planets_climates, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")

      add :planet_id, references(:planets, type: :uuid), null: false
      add :climate_id, references(:climates, type: :string), null: false
    end

    create unique_index(:planets_climates, [:planet_id, :climate_id],
             name: "unique_planets_climates"
           )
  end
end

defmodule StarWarsAPI.Repo.Migrations.CreatePlanetsMovies do
  use Ecto.Migration

  def change do
    create table(:planets_movies, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")

      add :planet_id, references(:planets, type: :uuid), null: false
      add :movie_id, references(:movies, type: :uuid), null: false
    end

    create unique_index(:planets_movies, [:planet_id, :movie_id], name: "unique_planets_movies")
  end
end

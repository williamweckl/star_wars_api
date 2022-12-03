defmodule StarWars.Repo.Migrations.AddDirectorIdToMovies do
  use Ecto.Migration

  def change do
    alter table("movies") do
      add :director_id, references(:movie_directors, type: :uuid), null: false
    end
  end
end

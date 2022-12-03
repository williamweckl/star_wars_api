defmodule StarWars.Repo.Migrations.AddMovieDirectorsNameUniqueIndex do
  use Ecto.Migration

  def change do
    create unique_index(:movie_directors, :name,
             name: "unique_movie_director_name",
             where: "deleted_at IS NULL"
           )
  end
end

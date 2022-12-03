defmodule StarWarsAPI.Repo.Migrations.CreateMovies do
  use Ecto.Migration

  def change do
    create table(:movies, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")

      add :title, :string, null: false, size: 255
      add :release_date, :date, null: false

      add :integration_source, :integration_source, null: false
      add :integration_id, :string

      add :deleted_at, :utc_datetime_usec
      timestamps(type: :utc_datetime_usec)
    end

    create index(:movies, :deleted_at)

    create unique_index(:movies, [:integration_source, :integration_id],
             name: "unique_movie_integration_id",
             where: "deleted_at IS NULL"
           )
  end
end

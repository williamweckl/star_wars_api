defmodule StarWarsAPI.Repo.Migrations.CreateMovieDirectors do
  use Ecto.Migration

  def change do
    create table(:movie_directors, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")

      add :name, :string, null: false, size: 255
      add :integration_source, :integration_source, null: false

      add :deleted_at, :utc_datetime_usec
      timestamps(type: :utc_datetime_usec)
    end

    create index(:movie_directors, :deleted_at)
  end
end

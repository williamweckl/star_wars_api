defmodule StarWars.Repo.Migrations.CreateTerrains do
  use Ecto.Migration

  def change do
    create table(:terrains, primary_key: false) do
      add :id, :string, primary_key: true

      add :name, :string, null: false, size: 60
      add :integration_source, :integration_source, null: false

      add :deleted_at, :utc_datetime_usec
      timestamps(type: :utc_datetime_usec)
    end

    create index(:terrains, :deleted_at)
  end
end

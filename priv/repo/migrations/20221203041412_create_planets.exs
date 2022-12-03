defmodule StarWars.Repo.Migrations.CreatePlanets do
  use Ecto.Migration

  def change do
    create table(:planets, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")

      add :name, :string, null: false, size: 60
      add :integration_source, :integration_source, null: false
      add :integration_id, :string

      add :deleted_at, :utc_datetime_usec
      timestamps(type: :utc_datetime_usec)
    end

    create index(:planets, :deleted_at)

    create unique_index(:planets, [:integration_source, :integration_id],
             name: "unique_planet_integration_id",
             where: "deleted_at IS NULL"
           )
  end
end

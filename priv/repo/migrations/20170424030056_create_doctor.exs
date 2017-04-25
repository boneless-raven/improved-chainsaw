defmodule Hnet.Repo.Migrations.CreateDoctor do
  use Ecto.Migration

  def change do
    create table(:doctors) do
      add :hospital_id, references(:hospitals, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end
    create index(:doctors, [:hospital_id])
    create index(:doctors, [:user_id])

  end
end

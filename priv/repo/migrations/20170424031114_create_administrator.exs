defmodule Hnet.Repo.Migrations.CreateAdministrator do
  use Ecto.Migration

  def change do
    create table(:administrators) do
      add :hospital_id, references(:hospitals, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end
    create index(:administrators, [:hospital_id])
    create index(:administrators, [:user_id])

  end
end

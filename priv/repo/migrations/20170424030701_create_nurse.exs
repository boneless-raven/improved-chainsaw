defmodule Hnet.Repo.Migrations.CreateNurse do
  use Ecto.Migration

  def change do
    create table(:nurses) do
      add :hospital_id, references(:hospitals, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end
    create index(:nurses, [:hospital_id])
    create index(:nurses, [:user_id])

  end
end

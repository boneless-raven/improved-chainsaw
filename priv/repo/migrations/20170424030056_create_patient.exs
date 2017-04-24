defmodule Hnet.Repo.Migrations.CreatePatient do
  use Ecto.Migration

  def change do
    create table(:patients) do
      add :proof_of_insurance, :string, null: false
      add :emergency_contact_name, :string
      add :emergency_contact_phone, :string
      add :emergency_contact_id, references(:patients, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end
    create index(:patients, [:emergency_contact_id])
    create index(:patients, [:user_id])

  end
end

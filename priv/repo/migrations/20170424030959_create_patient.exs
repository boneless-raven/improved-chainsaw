defmodule Hnet.Repo.Migrations.CreatePatient do
  use Ecto.Migration

  def change do
    create table(:patients) do
      add :proof_of_insurance, :string, null: false
      add :emergency_contact_name, :string
      add :emergency_contact_phone, :string
      add :emergency_contact_id, references(:patients, on_delete: :nilify_all)
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :primary_doctor_id, references(:doctors, on_delete: :nothing), null: false

      timestamps()
    end
    create index(:patients, [:emergency_contact_id])
    create index(:patients, [:user_id])
    create index(:patients, [:primary_doctor_id])
  end
end

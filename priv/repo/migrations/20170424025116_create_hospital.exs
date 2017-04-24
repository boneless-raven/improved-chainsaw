defmodule Hnet.Repo.Migrations.CreateHospital do
  use Ecto.Migration

  def change do
    create table(:hospitals) do
      add :name, :string, null: false
      add :location, :text, null: false
      add :operational, :boolean, default: true, null: false

      timestamps()
    end

  end
end

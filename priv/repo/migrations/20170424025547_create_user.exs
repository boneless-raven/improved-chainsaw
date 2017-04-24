defmodule Hnet.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :email, :string, null: false
      add :phone, :string, null: false
      add :address, :string, null: false
      add :gender, :string
      add :account_type, :string
      add :username, :string, null: false
      add :password_hash, :string, null: false

      timestamps()
    end

  end
end

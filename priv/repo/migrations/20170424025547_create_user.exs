defmodule Hnet.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    Hnet.Account.User.GenderEnum.create_type
    Hnet.Account.User.AccountTypeEnum.create_type
    create table(:users) do
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :email, :string, null: false
      add :phone, :string, null: false
      add :address, :string, null: false
      add :gender, :gender, null: false
      add :account_type, :account_type, null: false
      add :username, :string, null: false
      add :password_hash, :string, null: false

      timestamps()
    end
    create unique_index(:users, [:username])

  end
end

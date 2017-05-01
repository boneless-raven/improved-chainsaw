defmodule Hnet.Account.User do
  use Hnet.Web, :model

  require EctoEnum
  EctoEnum.defenum GenderEnum, :gender, [:male, :female]
  EctoEnum.defenum AccountTypeEnum, :account_type, [:patient, :doctor, :nurse, :administrator]

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :phone, :string
    field :address, :string
    field :gender, GenderEnum
    field :account_type, AccountTypeEnum
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    has_one :patient, Hnet.Account.Patient
    has_one :administrator, Hnet.Account.Administrator
    has_one :doctor, Hnet.Account.Doctor
    has_one :nurse, Hnet.Account.Nurse

    timestamps()
  end

  def fullname(user) do
    "#{user.first_name} #{user.last_name}"
  end
end
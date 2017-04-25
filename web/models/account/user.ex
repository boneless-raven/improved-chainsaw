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

    timestamps()
  end

  def fullname(user) do
    "#{user.first_name} #{user.last_name}"
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:first_name, :last_name, :email, :phone, :address, :gender, :account_type])
    |> validate_required([:first_name, :last_name, :email, :phone, :address, :gender, :account_type])
  end
end

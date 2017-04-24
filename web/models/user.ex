defmodule Hnet.User do
  use Hnet.Web, :model

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :phone, :string
    field :address, :string
    field :gender, :string
    field :account_type, :string
    field :username, :string
    field :password_hash, :string

    has_one :patient, Hnet.Patient

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:first_name, :last_name, :email, :phone, :address, :gender, :account_type, :username, :password_hash])
    |> validate_required([:first_name, :last_name, :email, :phone, :address, :gender, :account_type, :username, :password_hash])
  end
end

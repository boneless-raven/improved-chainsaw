defmodule Hnet.Account.Patient do
  use Hnet.Web, :model

  schema "patients" do
    field :proof_of_insurance, :string
    field :emergency_contact_name, :string
    field :emergency_contact_phone, :string
    belongs_to :emergency_contact, Hnet.Account.Patient
    belongs_to :user, Hnet.Account.User
    belongs_to :primary_doctor, Hnet.Account.Doctor

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:proof_of_insurance, :emergency_contact_name, :emergency_contact_phone])
    |> validate_required([:proof_of_insurance, :emergency_contact_name, :emergency_contact_phone])
  end
end

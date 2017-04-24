defmodule Hnet.Account.Registration do
  import Hnet.Changeset.Validation
  import Ecto.Changeset
  import Comeonin.Bcrypt

  alias Hnet.Account.User
  alias Hnet.Account.Patient

  @user_fields [:first_name, :last_name, :email, :phone, :address, :gender, :username, :password]
  @patient_fields [:proof_of_insurance, :emergency_contact_name, :emergency_contact_phone]

  def new_user(params \\ %{}) do
    %User{}
    |> cast(params, @user_fields)
    |> validate_required(@user_fields)
    |> validate_email(:email)
    |> validate_phone(:phone)
    |> validate_confirmation(:password)
    |> hash_password
    |> unique_constraint(:username)
  end

  def new_patient(user_params \\ %{}) do
    patient_params = user_params["patient"] || %{}

    patient_changeset = %Patient{}
    |> cast(patient_params, @patient_fields)
    |> validate_required([:proof_of_insurance])

    new_user(user_params)
    |> put_assoc(:patient, patient_changeset)
    |> put_change(:account_type, :patient)
  end

  defp hash_password(changeset) do
    if changeset.valid? do
      password = get_field(changeset, :password) || ""
      put_change(changeset, :password_hash, hashpwsalt(password))
    else
      changeset
    end
  end
end
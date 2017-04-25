defmodule Hnet.Account.Registration do
  import Hnet.Changeset.Validation
  import Ecto.Changeset
  import Comeonin.Bcrypt

  alias Hnet.Account.User
  alias Hnet.Account.Patient
  alias Hnet.Account.Administrator
  alias Hnet.Account.Doctor
  alias Hnet.Account.Nurse

  @user_fields [:first_name, :last_name, :email, :phone, :address, :gender, :username, :password]
  @patient_fields [:primary_doctor_id, :proof_of_insurance, :emergency_contact_name, :emergency_contact_phone]
  @admin_fields [:hospital_id]
  @doctor_fields [:hospital_id]
  @nurse_fields [:hospital_id]

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

  def new_administrator(user_params \\ %{}) do
    admin_params = user_params["administrator"] || %{}

    admin_changeset = %Administrator{}
    |> cast(admin_params, @admin_fields)
    |> validate_required(@admin_fields)

    new_user(user_params)
    |> put_assoc(:administrator, admin_changeset)
    |> put_change(:account_type, :administrator)
  end
  
  def new_doctor(user_params \\ %{}) do
    doctor_params = user_params["doctor"] || %{}

    doctor_changeset = %Doctor{}
    |> cast(doctor_params, @doctor_fields)
    |> validate_required(@doctor_fields)

    new_user(user_params)
    |> put_assoc(:doctor, doctor_changeset)
    |> put_change(:account_type, :doctor)
  end

  def new_nurse(user_params \\ %{}) do
    nurse_params = user_params["nurse"] || %{}

    nurse_changeset = %Nurse{}
    |> cast(nurse_params, @nurse_fields)
    |> validate_required(@nurse_fields)

    new_user(user_params)
    |> put_assoc(:nurse, nurse_changeset)
    |> put_change(:account_type, :nurse)
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
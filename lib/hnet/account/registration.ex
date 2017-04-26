defmodule Hnet.Account.Registration do
  @moduledoc """
  A module for handling user registration.
  """

  import Hnet.Changeset.Validation
  import Ecto.Changeset
  import Comeonin.Bcrypt

  alias Hnet.Account.User
  alias Hnet.Account.Patient
  alias Hnet.Account.Administrator
  alias Hnet.Account.Doctor
  alias Hnet.Account.Nurse
  
  alias Hnet.Helpers.Map

  @user_fields [:first_name, :last_name, :email, :phone, :address, :gender, :username, :password]
  @patient_fields [:primary_doctor_id, :proof_of_insurance, :emergency_contact_name, :emergency_contact_phone]
  @admin_fields [:hospital_id]
  @doctor_fields [:hospital_id]
  @nurse_fields [:hospital_id]

  @doc """
  Build a changeset for creating new user with the given params.
  """
  def new_user(params) do
    %User{}
    |> cast(params, @user_fields)
    |> validate_required(@user_fields)
    |> validate_email(:email)
    |> validate_phone(:phone)
    |> validate_confirmation(:password)
    |> hash_password
    |> unique_constraint(:username)
  end

  @doc """
  Build a changeset for creating new patient with the given params.
  """
  def new_patient(user_params \\ %{}) do
    patient_params = Map.retrieve(user_params, :patient) || %{}

    # Builds changeset validations against the patient data.
    patient_changeset = %Patient{}
    |> cast(patient_params, @patient_fields)
    |> validate_required([:primary_doctor_id, :proof_of_insurance])
    |> assoc_constraint(:primary_doctor)

    # Associate the patient changeset with the user changeset.
    new_user(user_params)
    |> put_assoc(:patient, patient_changeset)
    |> put_change(:account_type, :patient)
  end

  @doc """
  Build a changeset for creating new administrator with the given params.
  """
  def new_administrator(user_params \\ %{}) do
    admin_params = Map.retrieve(user_params, :administrator) || %{}

    # Builds changeset validations against the administrator data.
    admin_changeset = %Administrator{}
    |> cast(admin_params, @admin_fields)
    |> validate_required(@admin_fields)
    |> assoc_constraint(:hospital)

    # Associate the administrator changeset with the user changeset.
    new_user(user_params)
    |> put_assoc(:administrator, admin_changeset)
    |> put_change(:account_type, :administrator)
  end
  
  @doc """
  Build a changeset for creating new doctor with the given params.
  """
  def new_doctor(user_params \\ %{}) do
    doctor_params = Map.retrieve(user_params, :doctor) || %{}

    # Builds changeset validations against the doctor data.
    doctor_changeset = %Doctor{}
    |> cast(doctor_params, @doctor_fields)
    |> validate_required(@doctor_fields)
    |> assoc_constraint(:hospital)

    # Associate the doctor changeset with the user changeset.
    new_user(user_params)
    |> put_assoc(:doctor, doctor_changeset)
    |> put_change(:account_type, :doctor)
  end

  @doc """
  Build a changeset for creating new nurse with the given params.
  """
  def new_nurse(user_params \\ %{}) do
    nurse_params = Map.retrieve(user_params, :nurse) || %{}

    # Builds changeset validations against the nurse data.
    nurse_changeset = %Nurse{}
    |> cast(nurse_params, @nurse_fields)
    |> validate_required(@nurse_fields)
    |> assoc_constraint(:hospital)

    # Associate the nurse changeset with the user changeset.
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
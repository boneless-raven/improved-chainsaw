defmodule Hnet.Account.Profile do
  @moduledoc """
  A module for handling the editing of user profile information.
  """

  alias Hnet.Repo
  import Hnet.Changeset.Transformation
  import Hnet.Changeset.Validation
  import Ecto.Changeset

  alias Hnet.Helpers.Map

  @user_fields [:first_name, :last_name, :email, :phone, :address, :gender]
  @required_patient_fields [:primary_doctor_id, :proof_of_insurance]
  @optional_patient_fields [:emergency_contact_name, :emergency_contact_phone]

  def update(user, params \\ %{}) do
    case user.account_type do
      :patient -> update_patient(user, params)
      _ -> update_user(user, params)
    end
  end

  def update_user(user, params) do
    user
    |> cast(params, @user_fields)
    |> validate_required(@user_fields)
    |> validate_email(:email)
    |> validate_phone(:phone)
    |> prepare_changes(fn changeset ->
         changeset
         |> trim(:email)
         |> trim(:phone)
         |> to_lowercase(:email)
       end)
  end

  def update_patient(user, user_params) do
    user = Repo.preload(user, :patient)
    
    patient_params = Map.retrieve(user_params, :patient) || %{}

    # Builds changeset validations against the patient data.
    patient_changeset = user.patient
    |> cast(patient_params, @required_patient_fields ++ @optional_patient_fields)
    |> validate_required(@required_patient_fields)
    |> assoc_constraint(:primary_doctor)
    
    # Associate the patient changeset with the user changeset.
    update_user(user, user_params)
    |> put_assoc(:patient, patient_changeset)
  end
end
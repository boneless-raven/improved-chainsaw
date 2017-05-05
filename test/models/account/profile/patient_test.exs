defmodule Hnet.Account.Profile.PatientTest do
  use Hnet.ModelCase

  import Hnet.DefaultModels

  alias Hnet.Account.Profile

  @valid_params %{address: "Somewhere", phone: "1230984576", gender: "female",
                  first_name: "Arya", last_name: "Stark", email: "arya.stark@mail.com",
                  patient: %{primary_doctor_id: nil,
                             proof_of_insurance: "Valar Morghulis",
                             emergency_contact_name: "Jaqen H'gar",
                             emergency_contact_phone: "0128934567"}}
  @empty_params %{patient: %{
    primary_doctor_id: "", proof_of_insurance: "",
    emergency_contact_name: "", emergency_contact_phone: ""
  }}

  setup do
    create_default_hospital()
    create_default_doctor()
    {:ok, user: create_default_patient()}
  end

  test "change profile with no changes", %{user: user} do
    assert user == user
    |> Profile.update_patient(%{})
    |> apply_changes
  end

  test "change profile with valid changes", %{user: user} do
    new_doctor_id = create_default_doctor("doctor").doctor.id
    params = set_primary_doctor_id(@valid_params, new_doctor_id)

    changeset = Profile.update_patient(user, params)
    assert changeset.valid?
    
    changed_user = apply_changes(changeset)
    assert changed_user.first_name == @valid_params.first_name
    assert changed_user.last_name == @valid_params.last_name
    assert changed_user.phone == @valid_params.phone
    assert changed_user.email == @valid_params.email
    assert changed_user.address == @valid_params.address
    assert changed_user.gender == :female
    assert changed_user.account_type == user.account_type
    assert changed_user.username == user.username
    assert changed_user.password_hash == user.password_hash
    assert changed_user.patient.primary_doctor_id == new_doctor_id
    assert changed_user.patient.proof_of_insurance == @valid_params.patient.proof_of_insurance
    assert changed_user.patient.emergency_contact_name == @valid_params.patient.emergency_contact_name
    assert changed_user.patient.emergency_contact_phone == @valid_params.patient.emergency_contact_phone
  end

  test "change profile with empty changes", %{user: user} do
    changeset = Profile.update_patient(user, @empty_params)
    refute changeset.valid?
    patient_changeset = changeset.changes.patient
    assert Keyword.has_key?(patient_changeset.errors, :primary_doctor_id)
    assert Keyword.has_key?(patient_changeset.errors, :proof_of_insurance)
    refute Keyword.has_key?(patient_changeset.errors, :emergency_contact_name)
    refute Keyword.has_key?(patient_changeset.errors, :emergency_contact_phone)
  end

  test "change profile with invalid primary doctor id", %{user: user} do
    new_doctor_id = user.patient.primary_doctor_id + 1
    params = %{patient: %{primary_doctor_id: new_doctor_id}}
    assert {:error, changeset} = Profile.update_patient(user, params) |> Repo.update
    patient_changeset = changeset.changes.patient
    assert Keyword.has_key?(patient_changeset.errors, :primary_doctor)
  end

  test "change profile with forbidden attrs", %{user: user} do
    assert user == user
    |> Profile.update_patient(%{user_id: user.patient.user_id + 1})
    |> apply_changes
  end

  defp set_primary_doctor_id(attrs, doctor_id) do
    Map.update!(attrs, :patient, fn p ->
      %{p | primary_doctor_id: doctor_id}
    end)
  end
end

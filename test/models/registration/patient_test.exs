defmodule Hnet.Registration.PatientTest do
  use Hnet.ModelCase

  import Hnet.DefaultModels

  alias Hnet.Account.Registration

  @valid_attrs %{address: "The Wall", email: "snow.john@mail.com", gender: "male", 
                 first_name: "John", last_name: "Snow", phone: "1230984576",
                 username: "josn00", password: "phoenix", password_confirmation: "phoenix", 
                 patient: %{proof_of_insurance: "very valid proof", primary_doctor_id: nil}}
  @empty_attrs %{}

  setup do
    hospital = create_default_hospital()
    doctor_user = create_default_doctor()
    {:ok, hospital: hospital, doctor_user: doctor_user}
  end

  test "changeset with valid attributes", %{doctor_user: doctor_user} do
    doctor_id = doctor_user.doctor.id
    changeset = set_primary_doctor_id(@valid_attrs, doctor_id) |> Registration.new_patient

    assert {:ok, user} = Repo.insert(changeset)
    assert user.first_name == @valid_attrs.first_name
    assert user.last_name == @valid_attrs.last_name
    assert user.phone == @valid_attrs.phone
    assert user.email == @valid_attrs.email
    assert user.username == @valid_attrs.username
    assert user.address == @valid_attrs.address
    assert user.account_type == :patient
    assert user.gender == :male
    assert user.password_hash
    assert user.patient.proof_of_insurance == @valid_attrs.patient.proof_of_insurance
    patient = Repo.preload user.patient, :primary_doctor
    assert patient.primary_doctor.id == doctor_id
  end

  test "changeset with invalid primary doctor id", %{doctor_user: doctor_user} do
    doctor_id = doctor_user.doctor.id
    assert {:error, changeset} = set_primary_doctor_id(@valid_attrs, doctor_id + 1)
    |> Registration.new_patient
    |> Repo.insert
    patient_changeset = get_change(changeset, :patient)
    assert Keyword.has_key?(patient_changeset.errors, :primary_doctor)
  end

  test "changeset with empty attributes" do
    changeset = Registration.new_patient(@empty_attrs)

    refute changeset.valid?
    assert Keyword.has_key?(changeset.errors, :phone)
    assert Keyword.has_key?(changeset.errors, :email)
    assert Keyword.has_key?(changeset.errors, :address)
    assert Keyword.has_key?(changeset.errors, :gender)
    assert Keyword.has_key?(changeset.errors, :first_name)
    assert Keyword.has_key?(changeset.errors, :last_name)
    assert Keyword.has_key?(changeset.errors, :username)
    assert Keyword.has_key?(changeset.errors, :password)
    patient_changeset = get_change(changeset, :patient)
    assert Keyword.has_key?(patient_changeset.errors, :proof_of_insurance)
    assert Keyword.has_key?(patient_changeset.errors, :primary_doctor_id)
  end

  defp set_primary_doctor_id(attrs, doctor_id) do
    Map.update!(attrs, :patient, fn p ->
      %{p | primary_doctor_id: doctor_id}
    end)
  end
end
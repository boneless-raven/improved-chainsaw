defmodule Hnet.UserController.PatientTest do
  use Hnet.ConnCase

  import Hnet.DefaultModels
  alias Hnet.Account.User

  @valid_attrs %{
    address: "Somewhere", phone: "1230984576", gender: "female",
    first_name: "Arya", last_name: "Stark", email: "arya.stark@mail.com",
    patient: %{
      primary_doctor_id: "",
      proof_of_insurance: "Death is whimsical today.",
      emergency_contact_name: "God of a thousand faces",
      emergency_contact_phone: "0128934567"
    }
  }
  @empty_attrs %{
    address: "", phone: "", gender: "", first_name: "", last_name: "", email: "",
    patient: %{
      primary_doctor_id: nil, proof_of_insurance: "",
      emergency_contact_name: "", emergency_contact_phone: ""
    }
  }

  test "get profile page", %{conn: conn} do
    create_default_hospital()
    create_default_doctor()
    user_id = create_default_patient().id

    conn
    |> login(user_id)
    |> get(user_path(conn, :edit_profile))
    |> assert_conn(:success, "Profile Information")
    |> assert_conn(:success, "Primary doctor")
    |> assert_conn(:success, "Proof of insurance")
    |> assert_conn(:success, "Emergency contact name")
    |> assert_conn(:success, "Emergency contact phone")
  end

  test "change profile with valid attrs", %{conn: conn} do
    create_default_hospital()
    create_default_doctor()
    user = create_default_patient()
    new_doctor_id = create_default_doctor("doctor").doctor.id
    params = set_primary_doctor_id(@valid_attrs, new_doctor_id)

    conn
    |> login(user.id)
    |> put(user_path(conn, :update_profile), user: params)
    |> assert_conn(&assert(get_flash(&1, :info) =~ "All changes saved"))

    changed_user = Repo.get(User, user.id) |> Repo.preload(:patient)
    assert changed_user.first_name == @valid_attrs.first_name
    assert changed_user.last_name == @valid_attrs.last_name
    assert changed_user.phone == @valid_attrs.phone
    assert changed_user.email == @valid_attrs.email
    assert changed_user.address == @valid_attrs.address
    assert changed_user.gender == :female
    assert changed_user.account_type == user.account_type
    assert changed_user.username == user.username
    assert changed_user.password_hash == user.password_hash
    assert changed_user.patient.primary_doctor_id == new_doctor_id
    assert changed_user.patient.proof_of_insurance == @valid_attrs.patient.proof_of_insurance
    assert changed_user.patient.emergency_contact_name == @valid_attrs.patient.emergency_contact_name
    assert changed_user.patient.emergency_contact_phone == @valid_attrs.patient.emergency_contact_phone
  end

  test "change profile with empty attrs", %{conn: conn} do
    create_default_hospital()
    create_default_doctor().doctor.id
    user = create_default_patient()

    conn
    |> login(user.id)
    |> put(user_path(conn, :update_profile), user: @empty_attrs)
    |> assert_conn(:success, "something went wrong")

    changed_user = Repo.get(User, user.id) |> Repo.preload(:patient)
    assert changed_user.first_name == user.first_name
    assert changed_user.last_name == user.last_name
    assert changed_user.phone == user.phone
    assert changed_user.email == user.email
    assert changed_user.address == user.address
    assert changed_user.gender == :male
    assert changed_user.account_type == user.account_type
    assert changed_user.username == user.username
    assert changed_user.password_hash == user.password_hash
    assert changed_user.patient.primary_doctor_id == user.patient.primary_doctor_id
    assert changed_user.patient.proof_of_insurance == user.patient.proof_of_insurance
    assert changed_user.patient.emergency_contact_name == user.patient.emergency_contact_name
    assert changed_user.patient.emergency_contact_phone == user.patient.emergency_contact_phone
  end

  defp set_primary_doctor_id(attrs, doctor_id) do
    Map.update!(attrs, :patient, fn p ->
      %{p | primary_doctor_id: doctor_id}
    end)
  end
end
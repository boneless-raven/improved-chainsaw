defmodule Hnet.Registration.PatientTest do
  use Hnet.ConnCase

  alias Hnet.Account.User
  alias Hnet.Account.Patient
  import Hnet.DefaultModels

  @valid_attrs %{address: "The Wall", email: "snow.john@mail.com", gender: "male", 
                 first_name: "John", last_name: "Snow", phone: "1230984576",
                 username: "josn00", password: "phoenix", password_confirmation: "phoenix", 
                 patient: %{proof_of_insurance: "very valid proof", primary_doctor_id: nil}}
  @invalid_attrs %{}

  test "registration page", %{conn: conn} do
    conn = get conn, registration_path(conn, :new_patient)
    assert html_response(conn, 200) =~ "New Patient"
  end

  test "registration with valid attrs", %{conn: conn} do
    # Prepare the patient data.
    create_default_hospital()
    doctor_id = create_default_doctor().doctor.id
    params = set_primary_doctor_id(@valid_attrs, doctor_id)

    # Send the request & check the response.
    conn = post conn, registration_path(conn, :create_patient), user: params
    assert redirected_to(conn) == user_path(conn, :index)

    # Check that the new user is automatically logged in.
    new_user_id = get_session(conn, :current_user_id)
    assert new_user_id

    # Check database.
    new_user = Repo.get(User, new_user_id)
    assert new_user
    assert new_user.username == @valid_attrs.username
    assert new_user.account_type == :patient
    assert Repo.get_by(Patient, user_id: new_user_id)
  end

  test "registration with invalid attrs", %{conn: conn} do
    # Send the request & check the response.
    conn = post conn, registration_path(conn, :create_patient), user: @invalid_attrs
    assert html_response(conn, 200) =~ "something went wrong"

    # Check that the new user is automatically logged in.
    refute get_session(conn, :current_user_id)

    # Check database.
    assert Repo.aggregate(User, :count, :id) == 0
  end

  test "registration page but logged in", %{conn: conn} do
    create_default_hospital()
    create_default_doctor()
    user_id = create_default_patient().id

    # Send the request & check the response.
    conn
    |> login(user_id)
    |> get(registration_path(conn, :new_patient))
    |> assert_conn(:redirect, page_path(conn, :index))
    |> assert_conn(&assert(get_session(&1, :current_user_id) == user_id))

    # Check database.
    assert Repo.aggregate(User, :count, :id) == 2
  end

  test "registration but logged in", %{conn: conn} do
    create_default_hospital()
    create_default_doctor()
    user_id = create_default_patient().id

    # Send the request & check the response.
    conn
    |> login(user_id)
    |> post(registration_path(conn, :create_patient))
    |> assert_conn(:redirect, page_path(conn, :index))
    |> assert_conn(&assert(get_session(&1, :current_user_id) == user_id))

    # Check database.
    assert Repo.aggregate(User, :count, :id) == 2
  end

  defp set_primary_doctor_id(attrs, doctor_id) do
    Map.update!(attrs, :patient, fn p ->
      %{p | primary_doctor_id: doctor_id}
    end)
  end
end
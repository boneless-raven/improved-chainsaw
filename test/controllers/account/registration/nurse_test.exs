defmodule Hnet.Registration.NurseTest do
  use Hnet.ConnCase

  alias Hnet.Account.User
  alias Hnet.Account.Nurse
  import Hnet.DefaultModels

  @valid_attrs %{address: "Winterfell", email: "sansa.stark@mail.com", gender: "female", 
                 first_name: "Sansa", last_name: "Stark", phone: "1230984576",
                 username: "sanstark", password: "phoenix", password_confirmation: "phoenix", 
                 nurse: %{hospital_id: nil}}
  @invalid_attrs %{}

  test "registration page", %{conn: conn} do
    create_default_hospital()
    user_id = create_default_administrator().id

    conn
    |> login(user_id)
    |> get(registration_path(conn, :new_nurse))
    |> assert_conn(:success, "New Nurse")
  end

  test "registration with valid attrs", %{conn: conn} do
    # Prepare the nurse data.
    hospital_id = create_default_hospital().id
    user_id = create_default_administrator().id
    params = set_hospital_id(@valid_attrs, hospital_id)

    # Send the request & check the response.
    conn = login conn, user_id
    conn = post conn, registration_path(conn, :create_nurse), user: params
    assert redirected_to(conn) == user_path(conn, :index)

    # Check session.
    assert get_session(conn, :current_user_id) == user_id

    # Check database.
    new_user = Repo.get_by(User, username: @valid_attrs.username)
    assert new_user
    assert new_user.account_type == :nurse
    assert Repo.get_by(Nurse, user_id: new_user.id)
  end

  test "registration with invalid attrs", %{conn: conn} do
    # Prepare the nurse data.
    create_default_hospital()
    user_id = create_default_administrator().id
    
    # Send the request & check the response.
    conn = login conn, user_id
    conn = post conn, registration_path(conn, :create_nurse), user: @invalid_attrs
    assert html_response(conn, 200) =~ "something went wrong"

    # Check that the new user is automatically logged in.
    assert get_session(conn, :current_user_id) == user_id

    # Check database.
    assert Repo.aggregate(User, :count, :id) == 1
  end

  test "registration page not logged in", %{conn: conn} do
    create_default_hospital()

    conn = get conn, registration_path(conn, :new_nurse)
    assert redirected_to(conn) =~ auth_path(conn, :signin)
  end

  test "registration not logged in", %{conn: conn} do
    # Prepare the nurse data.
    hospital_id = create_default_hospital().id
    params = set_hospital_id(@valid_attrs, hospital_id)

    # Send the request & check the response.
    conn = post conn, registration_path(conn, :create_nurse), user: params
    assert redirected_to(conn) =~ auth_path(conn, :signin)

    # Check database.
    assert Repo.aggregate(User, :count, :id) == 0
    assert Repo.aggregate(Nurse, :count, :id) == 0
  end

  test "registration page logged in as doctor", %{conn: conn} do
    create_default_hospital()
    user_id = create_default_doctor().id

    conn
    |> login(user_id)
    |> get(registration_path(conn, :new_nurse))
    |> assert_conn(:redirect, :similar_to, auth_path(conn, :signin))
  end

  test "registration logged in as doctor", %{conn: conn} do
    # Prepare the nurse data.
    hospital_id = create_default_hospital().id
    user_id = create_default_doctor().id
    params = set_hospital_id(@valid_attrs, hospital_id)

    # Send the request & check the response.
    conn
    |> login(user_id)
    |> post(registration_path(conn, :create_nurse), user: params)
    |> assert_conn(:redirect, :similar_to, auth_path(conn, :signin))

    # Check database.
    assert Repo.aggregate(User, :count, :id) == 1
    assert Repo.aggregate(Nurse, :count, :id) == 0
  end

  defp set_hospital_id(attrs, hospital_id) do
    Map.update!(attrs, :nurse, fn d ->
      %{d | hospital_id: hospital_id}
    end)
  end
end
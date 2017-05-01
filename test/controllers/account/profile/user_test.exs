defmodule Hnet.UserController.UserTest do
  use Hnet.ConnCase

  import Hnet.DefaultModels
  alias Hnet.Account.User
  
  @valid_attrs %{
    address: "Grave. Rest in peace.", phone: "0192837465", gender: "male",
    first_name: "Robert", last_name: "Baratheon", email: "robert.baratheon@mail.com"
  }
  @empty_attrs %{address: "", phone: "", gender: "", first_name: "", last_name: "", email: ""}

  test "get profile page", %{conn: conn} do
    create_default_hospital()
    user_id = create_default_doctor().id

    conn
    |> login(user_id)
    |> get(user_path(conn, :edit_profile))
    |> assert_conn(:success, "Profile Information")
  end

  test "get profile page not logged in", %{conn: conn} do
    conn = get conn, user_path(conn, :edit_profile)
    assert redirected_to(conn) =~ auth_path(conn, :signin)
  end

  test "change profile with valid attrs", %{conn: conn} do
    create_default_hospital()
    user = create_default_doctor()

    conn
    |> login(user.id)
    |> put(user_path(conn, :update_profile), user: @valid_attrs)
    |> assert_conn(&assert(get_flash(&1, :info) =~ "All changes saved"))

    changed_user = Repo.get(User, user.id) |> Repo.preload(:doctor)
    assert changed_user.first_name == @valid_attrs.first_name
    assert changed_user.last_name == @valid_attrs.last_name
    assert changed_user.phone == @valid_attrs.phone
    assert changed_user.email == @valid_attrs.email
    assert changed_user.address == @valid_attrs.address
    assert changed_user.gender == :male
    assert changed_user.account_type == user.account_type
    assert changed_user.username == user.username
    assert changed_user.password_hash == user.password_hash
    assert changed_user.doctor.hospital_id == user.doctor.hospital_id
  end

  test "change profile with empty attrs", %{conn: conn} do
    create_default_hospital()
    user = create_default_administrator()

    conn
    |> login(user.id)
    |> put(user_path(conn, :update_profile), user: @empty_attrs)
    |> assert_conn(:success, "something went wrong")

    changed_user = Repo.get(User, user.id) |> Repo.preload(:administrator)
    assert changed_user.first_name == user.first_name
    assert changed_user.last_name == user.last_name
    assert changed_user.phone == user.phone
    assert changed_user.email == user.email
    assert changed_user.address == user.address
    assert changed_user.gender == :male
    assert changed_user.account_type == user.account_type
    assert changed_user.username == user.username
    assert changed_user.password_hash == user.password_hash
    assert changed_user.administrator.hospital_id == user.administrator.hospital_id
  end
end
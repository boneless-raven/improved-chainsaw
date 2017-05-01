defmodule Hnet.PageControllerTest do
  use Hnet.ConnCase

  import Hnet.DefaultModels

  test "home page with anonymous user", %{conn: conn} do
    conn = get conn, page_path(conn, :index)
    assert html_response(conn, 200) =~ "Welcome to HealthNet!"
  end

  test "homepage with patient user", %{conn: conn} do
    create_default_hospital()
    create_default_doctor()
    user_id = create_default_patient().id

    conn
    |> login(user_id)
    |> get(page_path(conn, :index))
    |> assert_conn(:redirect, page_path(conn, :patient))
  end

  test "homepage with administrator user", %{conn: conn} do
    create_default_hospital()
    user_id = create_default_administrator().id

    conn
    |> login(user_id)
    |> get(page_path(conn, :index))
    |> assert_conn(:redirect, page_path(conn, :administrator))
  end

  test "homepage with doctor user", %{conn: conn} do
    create_default_hospital()
    user_id = create_default_doctor().id

    conn
    |> login(user_id)
    |> get(page_path(conn, :index))
    |> assert_conn(:redirect, page_path(conn, :doctor))
  end

  test "homepage with nurse user", %{conn: conn} do
    create_default_hospital()
    user_id = create_default_nurse().id

    conn
    |> login(user_id)
    |> get(page_path(conn, :index))
    |> assert_conn(:redirect, page_path(conn, :nurse))
  end

  test "patient dashboard as patient", %{conn: conn} do
    create_default_hospital()
    create_default_doctor()
    user_id = create_default_patient().id

    conn
    |> login(user_id)
    |> get(page_path(conn, :patient))
    |> assert_conn(:success, "Patient Dashboard")
  end

  test "patient dashboard not logged in", %{conn: conn} do
    conn = get conn, page_path(conn, :patient)
    assert redirected_to(conn) =~ auth_path(conn, :signin)
  end

  test "administrator dashboard as administrator", %{conn: conn} do
    create_default_hospital()
    user_id = create_default_administrator().id

    conn
    |> login(user_id)
    |> get(page_path(conn, :administrator))
    |> assert_conn(:success, "Administrator Dashboard")
  end

  test "administrator dashboard as doctor", %{conn: conn} do
    create_default_hospital()
    user_id = create_default_doctor().id

    conn
    |> login(user_id)
    |> get(page_path(conn, :administrator))
    |> assert_conn(:redirect, :similar_to, auth_path(conn, :signin))
  end

  test "doctor dashboard as doctor", %{conn: conn} do
    create_default_hospital()
    user_id = create_default_doctor().id

    conn
    |> login(user_id)
    |> get(page_path(conn, :doctor))
    |> assert_conn(:success, "Doctor Dashboard")
  end

  test "doctor dashboard as nurse", %{conn: conn} do
    create_default_hospital()
    user_id = create_default_nurse().id

    conn
    |> login(user_id)
    |> get(page_path(conn, :doctor))
    |> assert_conn(:redirect, :similar_to, auth_path(conn, :signin))
  end

  test "nurse dashboard as nurse", %{conn: conn} do
    create_default_hospital()
    user_id = create_default_nurse().id

    conn
    |> login(user_id)
    |> get(page_path(conn, :nurse))
    |> assert_conn(:success, "Nurse Dashboard")
  end

  test "nurse dashboard as administrator", %{conn: conn} do
    create_default_hospital()
    user_id = create_default_administrator().id

    conn
    |> login(user_id)
    |> get(page_path(conn, :nurse))
    |> assert_conn(:redirect, :similar_to, auth_path(conn, :signin))
  end
end

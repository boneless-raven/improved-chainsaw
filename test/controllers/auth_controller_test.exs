defmodule Hnet.AuthControllerTest do
  use Hnet.ConnCase

  import Hnet.DefaultModels

  test "signin page", %{conn: conn} do
    conn = get conn, auth_path(conn, :signin)
    assert html_response(conn, 200) =~ "Sign In"
  end

  test "signin page already logged in", %{conn: conn} do
    create_default_hospital()
    user_id = create_default_administrator().id

    assert conn
    |> login(user_id)
    |> get(auth_path(conn, :signin))
    |> redirected_to =~ page_path(conn, :index)
  end

  test "login with valid credentials", %{conn: conn} do
    create_default_hospital()
    user_id = create_default_administrator().id

    credentials = %{ 
      "username" => "tyrlan", 
      "password" => "phoenix" 
    } 

    conn = post conn, auth_path(conn, :login), login_credentials: credentials
    assert redirected_to(conn) =~ page_path(conn, :index)
    assert get_session(conn, :current_user_id) == user_id
  end

  test "login with invalid username", %{conn: conn} do
    create_default_hospital()
    create_default_administrator().id

    credentials = %{ 
      "username" => "theimp", 
      "password" => "phoenix" 
    }

    conn = post conn, auth_path(conn, :login), login_credentials: credentials
    assert html_response(conn, 200) =~ "Sign In"
    assert html_response(conn, 200) =~ "Wrong username or password"
    assert get_session(conn, :current_user_id) == nil
  end

  test "login with invalid password", %{conn: conn} do
    create_default_hospital()
    create_default_administrator().id

    credentials = %{ 
      "username" => "tyrlan", 
      "password" => "wine" 
    }

    conn = post conn, auth_path(conn, :login), login_credentials: credentials
    assert html_response(conn, 200) =~ "Sign In"
    assert html_response(conn, 200) =~ "Wrong username or password"
    assert get_session(conn, :current_user_id) == nil
  end

  test "login already logged in", %{conn: conn} do
    create_default_hospital()
    create_default_doctor().id
    patient_user_id = create_default_patient().id

    credentials = %{
      "username" => "hsparrow", 
      "password" => "phoenix" 
    }

    conn
    |> login(patient_user_id)
    |> post(auth_path(conn, :login), login_credentials: credentials)
    |> assert_conn(:redirect, page_path(conn, :index))
    |> assert_conn(&assert(get_session(&1, :current_user_id) == patient_user_id))
  end

  test "logout", %{conn: conn} do
    create_default_hospital()
    user_id = create_default_administrator().id

    conn
    |> login(user_id)
    |> post(auth_path(conn, :logout))
    |> assert_conn(:redirect, page_path(conn, :index))
    |> assert_conn(&assert(get_session(&1, :current_user_id) == nil))
  end

  test "logout when not logged in", %{conn: conn} do
    create_default_hospital()

    conn
    |> post(auth_path(conn, :logout))
    |> assert_conn(:redirect, page_path(conn, :index))
    |> assert_conn(&assert(get_session(&1, :current_user_id) == nil))
  end
end
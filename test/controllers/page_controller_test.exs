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
    create_default_patient()

    credentials = %{
      "username" => "hound",
      "password" => "phoenix"
    }

    conn = conn
    |> post(auth_path(conn, :login), login_credentials: credentials)
    |> get(page_path(conn, :index))

    assert redirected_to(conn) =~ page_path(conn, :patient)
  end

  test "homepage with administrator user", %{conn: conn} do
    create_default_hospital()
    user_id = create_default_administrator().id

    conn = conn
    |> bypass_through(Hnet.Router, [:browser])
    |> get("/")
    |> put_session(:current_user_id, user_id)
    |> send_resp(:ok, "")
    |> recycle
    |> get(page_path(conn, :index))

    assert redirected_to(conn) =~ page_path(conn, :administrator)
  end
end

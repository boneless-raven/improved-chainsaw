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
end

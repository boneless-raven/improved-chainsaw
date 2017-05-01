defmodule Hnet.Plugs.RestrictAccessTest do
  use Hnet.ConnCase

  import Hnet.DefaultModels
  alias Hnet.Account.Plugs.RestrictAccess

  test "restrict to administrator not logged in", %{conn: conn} do
    opts = RestrictAccess.init(to: :administrator)

    conn = conn
    |> bypass_through(Hnet.Router, [:browser])
    |> get("/")
    |> RestrictAccess.call(opts)
    assert redirected_to(conn) =~ auth_path(conn, :signin)
    flash = get_flash(conn, :error)
    assert flash =~ "You're not logged in"
    assert flash =~ "administrator"
    assert conn.halted
  end

  test "restrict to administrator logged in as doctor", %{conn: conn} do
    create_default_hospital()
    user_id = create_default_doctor().id
    opts = RestrictAccess.init(to: :administrator)

    conn = conn
    |> login(user_id)
    |> bypass_through(Hnet.Router, [:browser])
    |> get("/")
    |> RestrictAccess.call(opts)
    assert redirected_to(conn) =~ auth_path(conn, :signin)
    flash = get_flash(conn, :error)
    assert flash =~ "You're logged in as doctor"
    assert flash =~ "administrator"
    assert conn.halted
  end

  test "restrict to doctor & nurse logged in as doctor", %{conn: conn} do
    create_default_hospital()
    user_id = create_default_doctor().id
    opts = RestrictAccess.init(to: [:doctor, :nurse])

    conn = conn
    |> login(user_id)
    |> bypass_through(Hnet.Router, [:browser])
    |> get("/")
    |> RestrictAccess.call(opts)
    refute get_flash(conn, :error)
    refute conn.halted
  end

  test "restrict to anonymous not logged in", %{conn: conn} do
    opts = RestrictAccess.init(to: :anonymous)

    conn = conn
    |> bypass_through(Hnet.Router, [:browser])
    |> get("/")
    |> RestrictAccess.call(opts)
    refute get_flash(conn, :error)
    refute conn.halted
  end

  test "restrict to anonymous logged in as patient", %{conn: conn} do
    create_default_hospital()
    create_default_doctor()
    user_id = create_default_patient().id
    opts = RestrictAccess.init(to: :anonymous)

    conn = conn
    |> login(user_id)
    |> bypass_through(Hnet.Router, [:browser])
    |> get("/")
    |> RestrictAccess.call(opts)

    assert redirected_to(conn) =~ auth_path(conn, :signin)
    flash = get_flash(conn, :error)
    assert flash =~ "You're logged in as patient"
    assert flash =~ "log out"
    assert conn.halted
  end

  test "restrict accss from anonymous not logged in", %{conn: conn} do
    opts = RestrictAccess.init(from: :anonymous)

    conn = conn
    |> bypass_through(Hnet.Router, [:browser])
    |> get("/")
    |> RestrictAccess.call(opts)

    assert redirected_to(conn) =~ auth_path(conn, :signin)
    flash = get_flash(conn, :error)
    assert flash =~ "You're not logged in"
    assert flash =~ "log in"
    assert conn.halted
  end

  test "restrict accss from anonymous logged in as administrator", %{conn: conn} do
    create_default_hospital()
    user_id = create_default_administrator().id
    opts = RestrictAccess.init(from: :anonymous)

    conn = conn
    |> login(user_id)
    |> bypass_through(Hnet.Router, [:browser])
    |> get("/")
    |> RestrictAccess.call(opts)

    refute get_flash(conn, :error)
    refute conn.halted
  end
end
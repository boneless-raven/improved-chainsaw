defmodule Hnet.Account.AuthController do
  use Hnet.Web, :controller
  alias Hnet.Account.Authentication

  def signin(conn, _params) do
    render conn, "signin.html"
  end

  def login(conn, %{"login_credentials" => login_params}) do
    case Authentication.login(conn, login_params) do
      :ok ->
        conn
        |> put_flash(:info, "Logged in")
        |> redirect(to: page_path(conn, :index))
      :error ->
        conn
        |> put_flash(:error, "Wrong username or password.")
        |> render("signin.html")
    end
  end

  def logout(conn, _params) do
    conn
    |> Authentication.delete_user
    |> put_flash(:info, "Logged out.")
    |> redirect(to: page_path(conn, :index))
  end
end
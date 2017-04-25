defmodule Hnet.Account.RegistrationController do
  use Hnet.Web, :controller

  alias Hnet.Account.Registration
  import Hnet.Account.Authentication

  def new_patient(conn, _params) do
    changeset = Registration.new_patient()
    render conn, "patient.html", changeset: changeset
  end

  def create_patient(conn, %{"user" => user_params}) do
    changeset = Registration.new_patient(user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_user(user)
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render conn, "patient.html", changeset: changeset
    end
  end
end
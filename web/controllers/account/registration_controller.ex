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
        |> put_flash(:info, "Account created successfully.")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render conn, "patient.html", changeset: changeset
    end
  end

  def new_administrator(conn, _params) do
    changeset = Registration.new_administrator()
    hospitals = Hnet.Repo.all(Hnet.Hospital)
    render conn, "administrator.html", changeset: changeset, hospitals: hospitals
  end

  def create_administrator(conn, %{"user" => user_params}) do
    changeset = Registration.new_administrator(user_params)

    case Repo.insert(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Administrator created successfully.")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        hospitals = Hnet.Repo.all(Hnet.Hospital)
        render conn, "administrator.html", changeset: changeset, hospitals: hospitals
    end
  end

  def new_doctor(conn, _params) do
    changeset = Registration.new_doctor()
    hospitals = Hnet.Repo.all(Hnet.Hospital)
    render conn, "doctor.html", changeset: changeset, hospitals: hospitals
  end

  def create_doctor(conn, %{"user" => user_params}) do
    changeset = Registration.new_doctor(user_params)

    case Repo.insert(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Doctor created successfully.")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        hospitals = Hnet.Repo.all(Hnet.Hospital)
        render conn, "doctor.html", changeset: changeset, hospitals: hospitals
    end
  end
end
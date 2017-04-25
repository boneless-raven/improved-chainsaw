defmodule Hnet.Account.RegistrationController do
  use Hnet.Web, :controller

  alias Hnet.Account.User
  alias Hnet.Account.Doctor
  alias Hnet.Account.Registration
  import Hnet.Account.Authentication
  import Ecto.Query

  def index(conn, _params) do
    render conn, "index.html"
  end

  def new_patient(conn, _params) do
    changeset = Registration.new_patient()
    doctor_options = get_doctor_options()
    render conn, "patient.html", changeset: changeset, doctor_options: doctor_options
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
        doctor_options = get_doctor_options()
        render conn, "patient.html", changeset: changeset, doctor_options: doctor_options
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

  def new_nurse(conn, _params) do
    changeset = Registration.new_nurse()
    hospitals = Hnet.Repo.all(Hnet.Hospital)
    render conn, "nurse.html", changeset: changeset, hospitals: hospitals
  end

  def create_nurse(conn, %{"user" => user_params}) do
    changeset = Registration.new_nurse(user_params)

    case Repo.insert(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Nurse created successfully.")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        hospitals = Hnet.Repo.all(Hnet.Hospital)
        render conn, "nurse.html", changeset: changeset, hospitals: hospitals
    end
  end

  defp get_doctor_options do
    query = from d in Doctor,
            join: u in User, on: d.user_id == u.id,
            select: {u, d.id}
    Hnet.Repo.all(query) |> Enum.map(fn {u, d_id} -> {User.fullname(u), d_id} end)
  end
end
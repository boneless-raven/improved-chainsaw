defmodule Hnet.HospitalController do
  use Hnet.Web, :controller

  alias Hnet.Hospital

  def index(conn, _params) do
    hospitals = Repo.all(Hospital)
    render(conn, "index.html", hospitals: hospitals)
  end

  def new(conn, _params) do
    changeset = Hospital.changeset(%Hospital{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"hospital" => hospital_params}) do
    changeset = Hospital.changeset(%Hospital{}, hospital_params)

    case Repo.insert(changeset) do
      {:ok, _hospital} ->
        conn
        |> put_flash(:info, "Hospital created successfully.")
        |> redirect(to: hospital_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    hospital = Repo.get!(Hospital, id)
    render(conn, "show.html", hospital: hospital)
  end

  def edit(conn, %{"id" => id}) do
    hospital = Repo.get!(Hospital, id)
    changeset = Hospital.changeset(hospital)
    render(conn, "edit.html", hospital: hospital, changeset: changeset)
  end

  def update(conn, %{"id" => id, "hospital" => hospital_params}) do
    hospital = Repo.get!(Hospital, id)
    changeset = Hospital.changeset(hospital, hospital_params)

    case Repo.update(changeset) do
      {:ok, hospital} ->
        conn
        |> put_flash(:info, "Hospital updated successfully.")
        |> redirect(to: hospital_path(conn, :show, hospital))
      {:error, changeset} ->
        render(conn, "edit.html", hospital: hospital, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    hospital = Repo.get!(Hospital, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(hospital)

    conn
    |> put_flash(:info, "Hospital deleted successfully.")
    |> redirect(to: hospital_path(conn, :index))
  end
end

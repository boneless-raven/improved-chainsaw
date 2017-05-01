defmodule Hnet.Account.UserController do
  use Hnet.Web, :controller

  import Hnet.Account.Authentication
  alias Hnet.Account.Profile
  alias Hnet.Account.User

  alias Hnet.Account.Plugs.RestrictAccess
  plug RestrictAccess, [to: :administrator] when action in [:delete]
  plug RestrictAccess, [from: :anonymous] when action in [:edit_profile, :update_profile]
  
  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.html", users: users)
  end

  def edit_profile(conn, _params) do
    user = conn.assigns[:current_user]
    render conn, profile_template_name(user.account_type), changeset: Profile.update(user)
  end

  def update_profile(conn, %{"user" => params}) do
    user = conn.assigns[:current_user]
    changeset = Profile.update(user, params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "All changes saved.")
        |> render(profile_template_name(user.account_type), changeset: changeset)
      {:error, changeset} ->
        render conn, profile_template_name(user.account_type), changeset: changeset
    end
  end

  defp profile_template_name(account_type) do
    case account_type do
      :patient -> "patient.html"
      _ -> "profile.html"
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.html", user: user)
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    conn
    |> delete_user
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end
end

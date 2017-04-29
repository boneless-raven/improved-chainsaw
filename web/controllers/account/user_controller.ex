defmodule Hnet.Account.UserController do
  use Hnet.Web, :controller

  import Ecto.Changeset

  import Hnet.Account.Authentication
  alias Hnet.Account.User

  alias Hnet.Account.Plugs.RestrictAccess
  plug RestrictAccess, [to: :administrator] when action in [:delete]
  plug RestrictAccess, [from: :anonymous] when action in [:profile]
  
  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.html", users: users)
  end

  def edit_profile(conn, params) do
    render_profile conn, conn.assigns[:current_user]
  end

  def update_profile(conn, params) do
    
  end

  defp render_profile(conn, user) do
    case user.account_type do
      :patient ->
        changeset = Repo.preload(user, :patient) |> change
        render(conn, "patient.html", changeset: changeset)
      _ ->
        render(conn, "profile.html", changeset: change(user))
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

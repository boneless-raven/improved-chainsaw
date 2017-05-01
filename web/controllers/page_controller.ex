defmodule Hnet.PageController do
  use Hnet.Web, :controller

  alias Hnet.Account.Plugs.RestrictAccess
  plug RestrictAccess, [to: :patient] when action in [:patient]
  plug RestrictAccess, [to: :administrator] when action in [:administrator]
  plug RestrictAccess, [to: :doctor] when action in [:doctor]
  plug RestrictAccess, [to: :nurse] when action in [:nurse]

  def index(conn, _params) do
    user = conn.assigns[:current_user]
    if user do
      redirect conn, to: page_path(conn, user.account_type)
    else
      render conn, "index.html"
    end
  end

  def patient(conn, _params) do
    render conn, "patient.html"
  end

  def administrator(conn, _params) do
    render conn, "administrator.html"
  end

  def doctor(conn, _params) do
    render conn, "doctor.html"
  end

  def nurse(conn, _params) do
    render conn, "nurse.html"
  end
end

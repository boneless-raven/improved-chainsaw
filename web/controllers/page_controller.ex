defmodule Hnet.PageController do
  use Hnet.Web, :controller

  alias Hnet.Account.RestrictAccess
  plug RestrictAccess, [to: :patient] when action in [:patient]
  plug RestrictAccess, [to: :administrator] when action in [:administrator]

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
end

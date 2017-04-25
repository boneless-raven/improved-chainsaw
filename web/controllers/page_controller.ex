defmodule Hnet.PageController do
  use Hnet.Web, :controller

  def index(conn, _params) do
    if conn.assigns[:current_user] do
      redirect conn, to: page_path(conn, :patient)
    else
      render conn, "index.html"
    end
  end

  def patient(conn, _params) do
    render conn, "patient.html"
  end
end

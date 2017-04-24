defmodule Hnet.PageController do
  use Hnet.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

defmodule Hnet.Account.AssignUser do
  import Plug.Conn
  alias Hnet.Account.Authentication

  def init(opts), do: opts

  def call(conn, _) do
    assign(conn, :current_user, Authentication.get_user(conn))
  end
end
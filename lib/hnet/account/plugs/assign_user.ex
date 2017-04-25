defmodule Hnet.Account.Plugs.AssignUser do
  @moduledoc ~S"""
  A plug that fetches the user id from the session,
  and fetches the user with that id from that database,
  and assigns the user struct or `nil`
  to `:current_user` in `conn`.
  """
  import Plug.Conn
  alias Hnet.Account.Authentication

  def init(opts), do: opts

  def call(conn, _) do
    assign(conn, :current_user, Authentication.get_user(conn))
  end
end
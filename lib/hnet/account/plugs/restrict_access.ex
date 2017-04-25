defmodule Hnet.Account.RestrictAccess do
  import Plug.Conn
  import Phoenix.Controller
  import Hnet.Router.Helpers
  
  def init(opts) do
    [to: Keyword.get(opts, :to, []) |> List.wrap,
     redirect: Keyword.get(opts, :redirect, nil)]
  end

  def call(conn, opts) do
    case conn.assigns[:current_user] do
      nil -> block_access(conn, nil, opts)
      user -> check_account_type(conn, user.account_type, opts)
    end
  end

  defp check_account_type(conn, account_type, opts) do
    if account_type in opts[:to] do
      conn
    else
      block_access(conn, account_type, opts)
    end
  end

  defp block_access(conn, account_type, opts) do
    conn
    |> put_flash(:error, message_for_account_type(account_type, opts))
    |> redirect(to: opts[:redirect] || auth_path(conn, :signin, next: conn.request_path))
    |> halt
  end

  defp message_for_account_type(nil, opts), do: "You're not logged in. #{signin_message(opts)}"
  defp message_for_account_type(account_type, opts) do
    "You're logged in as #{account_type}, but you're not authorized to view this page. #{signin_message(opts)}"
  end

  defp signin_message(opts) do
    "Please sign in as #{Enum.join(opts[:to], " or ")} to view this page."
  end
end
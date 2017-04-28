defmodule Hnet.Account.Plugs.RestrictAccess do
  @moduledoc """
  A plug that restrict access based on the current user's account type.
  If the user isn't logged in or isn't the allowed account types, 
  the user will be redirected to the given redirect URL,
  or the login page.
  An `:error` flash message will also be inserted
  to notify the user to sign in to an authorized accounts.

  ## Supported Options
  * `:to` can be an atom or a list of atoms
          containing one or more account types that are allowed access.
  * `:redirect` is the URL to redirect to if the user doesn't have access.

  ## Examples
  Restrict access to the `:delete` controller action
  to be only available to the `:administrator` account type.

      plug Hnet.Account.Plugs.RestrictAccess, [to: :administrator] when action in [:delete]

  Restrict access to the `:show` controller action
  to be only available to `:doctor` and `:nurse` account type.

      plug Hnet.Account.Plugs.RestrictAccess, [to: [:doctor, :nurse]] when action in [:show]

  """

  import Plug.Conn
  import Phoenix.Controller
  import Hnet.Router.Helpers
  
  def init(opts) do
    [to: Keyword.get(opts, :to, []) |> List.wrap,
     redirect: Keyword.get(opts, :redirect, nil)]
  end

  def call(conn, opts) do
    case conn.assigns[:current_user] do
      nil -> check_account_type(conn, :anonymous, opts)
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
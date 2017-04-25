defmodule Hnet.Account.Authentication do
  @moduledoc """
  A module that manages the logic for authenticating users.
  """

  import Plug.Conn
  import Comeonin.Bcrypt

  @doc """
  Try to log the user in with the given `credentials`.
  If the credentials are valid,
  then the id of that user will be put in the session
  under the key `:current_user_id`.

  Returns `{:ok, conn}` if the user is successfully logged in;
  or `:error` if the login atttempt failed.
  """
  def login(conn, credentials) do
    user = Hnet.Repo.get_by(Hnet.Account.User, username: String.downcase(credentials["username"]))
    case authenticate(user, credentials["password"]) do
      true -> {:ok, put_user(conn, user)}
      _ -> :error
    end
  end

  defp authenticate(nil, _password) do
    false
  end

  defp authenticate(user, password) do
    checkpw(password, user.password_hash)
  end

  @doc """
  Puts the id of the given user into the session
  under the key `:current_user_id`.
  """
  def put_user(conn, user) do
    put_session(conn, :current_user_id, user.id)
  end

  @doc """
  Fetches the user data from the database
  with the id stored in session under the key `:current_user_id`.
  Returns the fetched user struct or `nil`.
  """
  def get_user(conn) do
    case get_session(conn, :current_user_id) do
      nil -> nil
      user_id ->
        Hnet.Repo.get!(Hnet.Account.User, user_id)
    end
  end

  @doc """
  Removes the current uesr id from session.
  """
  def delete_user(conn) do
    delete_session(conn, :current_user_id)
  end
end
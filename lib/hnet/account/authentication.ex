defmodule Hnet.Account.Authentication do
  import Plug.Conn
  import Comeonin.Bcrypt

  def login(conn, params) do
    user = Hnet.Repo.get_by(Hnet.Account.User, username: String.downcase(params["username"]))
    case authenticate(user, params["password"]) do
      true -> 
        {:ok, put_user(conn, user)}
      _ -> :error
    end
  end

  defp authenticate(nil, _password) do
    false
  end

  defp authenticate(user, password) do
    checkpw(password, user.password_hash)
  end

  def put_user(conn, user) do
    put_session(conn, :current_user_id, user.id)
  end

  def get_user(conn) do
    case get_session(conn, :current_user_id) do
      nil -> nil
      user_id ->
        Hnet.Repo.get!(Hnet.Account.User, user_id)
    end
  end

  def delete_user(conn) do
    delete_session(conn, :current_user_id)
  end
end
defmodule Hnet.Account.FormView do
  use Hnet.Web, :view

  import Ecto.Query
  alias Hnet.Account.User
  alias Hnet.Account.Doctor

  def get_doctor_options do
    query = from d in Doctor,
            join: u in User, on: d.user_id == u.id,
            select: {u, d.id}
    Hnet.Repo.all(query) |> Enum.map(fn {u, d_id} -> {User.fullname(u), d_id} end)
  end
end
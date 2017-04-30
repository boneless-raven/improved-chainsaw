defmodule Hnet.Account.FormView do
  use Hnet.Web, :view

  import Ecto.Query
  alias Hnet.Repo
  alias Hnet.Account.User
  alias Hnet.Account.Doctor
  alias Hnet.Hospital

  def get_doctor_options do
    query = from d in Doctor,
            join: u in User, on: d.user_id == u.id,
            select: {u, d.id}
    Repo.all(query) |> Enum.map(fn {u, d_id} -> {User.fullname(u), d_id} end)
  end

  def get_hospital_options do
    Repo.all(Hospital) |> Enum.map(&{&1.name, &1.id})
  end
end
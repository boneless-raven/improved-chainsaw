defmodule Hnet.DefaultModels do
  alias Hnet.Repo

  import Ecto.Query
  import Ecto.Changeset
  
  alias Hnet.Hospital
  alias Hnet.Account.User

  def create_default_hospital do
    record = %Hospital{name: "Baelor's Sept", location: "King's Landing"}
    Repo.insert!(record)
  end

  def create_default_doctor do
    query = from h in Hospital, select: h.id, limit: 1
    hospital_id = List.first(Repo.all(query))
    %User{address: "Baelor's Sept", email: "high.sparrow@mail.com", first_name: "高",
          last_name: "麻雀", gender: "male", phone: "1230984576", username: "hsparrow",
          password_hash: "agw8w3ohwgf8hW49", account_type: :doctor}
    |> change
    |> put_assoc(:doctor, %{hospital_id: hospital_id})
    |> Repo.insert!
  end
end
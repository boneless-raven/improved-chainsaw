defmodule Hnet.Doctor do
  use Hnet.Web, :model

  schema "doctors" do
    belongs_to :hospital, Hnet.Hospital
    belongs_to :user, Hnet.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end
end

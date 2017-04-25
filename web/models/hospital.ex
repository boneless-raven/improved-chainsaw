defmodule Hnet.Hospital do
  use Hnet.Web, :model

  alias Hnet.Account.Administrator
  alias Hnet.Account.Doctor
  alias Hnet.Account.Nurse

  schema "hospitals" do
    field :name, :string
    field :location, :string
    field :operational, :boolean, default: true

    has_many :administrators, Administrator
    has_many :doctors, Doctor
    has_many :nurses, Nurse

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :location, :operational])
    |> validate_required([:name, :location, :operational])
  end
end

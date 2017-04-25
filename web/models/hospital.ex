defmodule Hnet.Hospital do
  use Hnet.Web, :model

  schema "hospitals" do
    field :name, :string
    field :location, :string
    field :operational, :boolean, default: true

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

defmodule Hnet.HospitalTest do
  use Hnet.ModelCase

  alias Hnet.Hospital

  @valid_attrs %{location: "some content", name: "some content", operational: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Hospital.changeset(%Hospital{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Hospital.changeset(%Hospital{}, @invalid_attrs)
    refute changeset.valid?
  end
end

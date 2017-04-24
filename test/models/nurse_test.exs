defmodule Hnet.NurseTest do
  use Hnet.ModelCase

  alias Hnet.Nurse

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Nurse.changeset(%Nurse{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Nurse.changeset(%Nurse{}, @invalid_attrs)
    refute changeset.valid?
  end
end

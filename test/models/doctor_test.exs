defmodule Hnet.DoctorTest do
  use Hnet.ModelCase

  alias Hnet.Doctor

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Doctor.changeset(%Doctor{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Doctor.changeset(%Doctor{}, @invalid_attrs)
    refute changeset.valid?
  end
end

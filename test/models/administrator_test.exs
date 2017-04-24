defmodule Hnet.AdministratorTest do
  use Hnet.ModelCase

  alias Hnet.Administrator

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Administrator.changeset(%Administrator{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Administrator.changeset(%Administrator{}, @invalid_attrs)
    refute changeset.valid?
  end
end

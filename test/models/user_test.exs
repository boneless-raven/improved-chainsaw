defmodule Hnet.UserTest do
  use Hnet.ModelCase

  alias Hnet.User

  @valid_attrs %{account_type: "some content", address: "some content", email: "some content", first_name: "some content", gender: "some content", last_name: "some content", password_hash: "some content", phone: "some content", username: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end

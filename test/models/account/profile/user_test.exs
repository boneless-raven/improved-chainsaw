defmodule Hnet.Account.Profile.UserTest do
  use Hnet.ModelCase

  import Hnet.DefaultModels

  alias Hnet.Account.Profile

  @valid_params %{address: "Also at the Red Keep, King's Landing.'", phone: "1230984576", gender: "male",
                  first_name: "Jamie", last_name: "Lannister", email: "jamie.lannister@mail.com"}
  @empty_params %{address: "", phone: "", gender: "", first_name: "", last_name: "", email: ""}
  @forbidden_attrs %{patient_id: 0, administrator_id: 0, doctor_id: 0, nurse_id: 0,
                     password_hash: "hash", account_type: :administrator}

  setup do
    {:ok, user: create_default_user()}
  end

  test "change profile with no changes", %{user: user} do
    assert user == user
    |> Profile.update_user(%{})
    |> apply_changes
  end

  test "change profile with valid changes", %{user: user} do
    changeset = Profile.update_user(user, @valid_params)
    assert changeset.valid?
    
    changed_user = apply_changes(changeset)
    assert changed_user.first_name == @valid_params.first_name
    assert changed_user.last_name == @valid_params.last_name
    assert changed_user.phone == @valid_params.phone
    assert changed_user.email == @valid_params.email
    assert changed_user.address == @valid_params.address
    assert changed_user.gender == :male
    assert changed_user.account_type == user.account_type
    assert changed_user.username == user.username
    assert changed_user.password_hash == user.password_hash
  end

  test "change profile with empty changes", %{user: user} do
    changeset = Profile.update_user(user, @empty_params)
    refute changeset.valid?
    assert Keyword.has_key?(changeset.errors, :phone)
    assert Keyword.has_key?(changeset.errors, :email)
    assert Keyword.has_key?(changeset.errors, :address)
    assert Keyword.has_key?(changeset.errors, :gender)
    assert Keyword.has_key?(changeset.errors, :first_name)
    assert Keyword.has_key?(changeset.errors, :last_name)
  end

  test "change profile with forbidden attrs", %{user: user} do
    assert user == user
    |> Profile.update_user(@forbidden_attrs)
    |> apply_changes
  end
end
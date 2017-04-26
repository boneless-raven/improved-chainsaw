defmodule Hnet.Registration.NurseTest do
  use Hnet.ModelCase

  import Hnet.DefaultModels
  alias Hnet.Account.Registration

  @valid_attrs %{address: "Winterfell", email: "sansa.stark@mail.com", gender: "female", 
                 first_name: "Sansa", last_name: "Stark", phone: "1230984576",
                 username: "sanstark", password: "phoenix", password_confirmation: "phoenix", 
                 nurse: %{hospital_id: nil}}
  @empty_attrs %{}

  setup do
    {:ok, hospital: create_default_hospital()}
  end

  test "changeset with valid attributes", %{hospital: hospital} do
    hospital_id = hospital.id
    params = set_hospital_id(@valid_attrs, hospital_id)
    changeset = Registration.new_nurse(params)
    assert changeset.valid?
    assert get_change(changeset, :first_name) == @valid_attrs.first_name
    assert get_change(changeset, :last_name) == @valid_attrs.last_name
    assert get_change(changeset, :phone) == @valid_attrs.phone
    assert get_change(changeset, :email) == @valid_attrs.email
    assert get_change(changeset, :username) == @valid_attrs.username
    assert get_change(changeset, :address) == @valid_attrs.address
    assert get_change(changeset, :account_type) == :nurse
    assert get_change(changeset, :gender) == :female
    assert {:ok, _} = fetch_change(changeset, :password_hash)
    nurse_changeset = get_change(changeset, :nurse)
    assert get_change(nurse_changeset, :hospital_id) == hospital_id
  end

  test "changeset with invalid hospital id", %{hospital: hospital} do
    hospital_id = hospital.id
    assert {:error, changeset} = set_hospital_id(@valid_attrs, hospital_id + 1)
    |> Registration.new_nurse
    |> Repo.insert
    nurse_changeset = get_change(changeset, :nurse)
    assert Keyword.has_key?(nurse_changeset.errors, :hospital)
  end

  test "changeset with empty attributes" do
    changeset = Registration.new_nurse(@empty_attrs)
    refute changeset.valid?
    assert Keyword.has_key?(changeset.errors, :phone)
    assert Keyword.has_key?(changeset.errors, :email)
    assert Keyword.has_key?(changeset.errors, :address)
    assert Keyword.has_key?(changeset.errors, :gender)
    assert Keyword.has_key?(changeset.errors, :first_name)
    assert Keyword.has_key?(changeset.errors, :last_name)
    assert Keyword.has_key?(changeset.errors, :username)
    assert Keyword.has_key?(changeset.errors, :password)
    nurse_changeset = get_change(changeset, :nurse)
    assert Keyword.has_key?(nurse_changeset.errors, :hospital_id)
  end

  defp set_hospital_id(attrs, hospital_id) do
    Map.update!(attrs, :nurse, fn d ->
      %{d | hospital_id: hospital_id}
    end)
  end

end
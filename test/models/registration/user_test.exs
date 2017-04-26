defmodule Hnet.Registration.UserTest do
  use Hnet.ModelCase

  alias Hnet.Account.Registration
  import Hnet.DefaultModels

  @valid_attrs %{address: "Red Keep, King's Landing", email: "baratheon.joffrey@mail.com", gender: "male", 
                 first_name: "Joffrey", last_name: "Baratheon", phone: "1230984576",
                 username: "bajo00", password: "phoenix", password_confirmation: "phoenix"}
  @invalid_format_attrs %{@valid_attrs | phone: "perfectly valid phone number", email: "perfectly valid email"}
  @inconsistent_password_attrs %{@valid_attrs | password_confirmation: "not " <> @valid_attrs.password}
  @empty_attrs %{}

  test "changeset with valid attributes" do
    changeset = Registration.new_user(@valid_attrs)
    assert changeset.valid?
    assert get_change(changeset, :first_name) == @valid_attrs.first_name
    assert get_change(changeset, :last_name) == @valid_attrs.last_name
    assert get_change(changeset, :phone) == @valid_attrs.phone
    assert get_change(changeset, :email) == @valid_attrs.email
    assert get_change(changeset, :username) == @valid_attrs.username
    assert get_change(changeset, :address) == @valid_attrs.address
    assert get_change(changeset, :gender) == :male
    assert {:ok, _} = fetch_change(changeset, :password_hash)
  end

  test "changeset with attributes with invalid formats" do
    changeset = Registration.new_user(@invalid_format_attrs)
    refute changeset.valid?
    assert Keyword.has_key?(changeset.errors, :phone)
    assert Keyword.has_key?(changeset.errors, :email)
  end

  test "changeset with attributes with inconsistent passwords" do
    changeset = Registration.new_user(@inconsistent_password_attrs)
    refute changeset.valid?
    assert Keyword.has_key?(changeset.errors, :password_confirmation)
  end

  test "changeset with repeated username" do
    create_default_hospital()
    doctor_user = create_default_doctor()
    assert {:error, changeset} = %{@valid_attrs | username: doctor_user.username}
    |> Registration.new_user
    |> put_change(:account_type, :doctor)
    |> Repo.insert
    assert Keyword.has_key?(changeset.errors, :username)
  end

  test "changeset with empty attributes" do
    changeset = Registration.new_user(@empty_attrs)
    refute changeset.valid?
    assert Keyword.has_key?(changeset.errors, :phone)
    assert Keyword.has_key?(changeset.errors, :email)
    assert Keyword.has_key?(changeset.errors, :address)
    assert Keyword.has_key?(changeset.errors, :gender)
    assert Keyword.has_key?(changeset.errors, :first_name)
    assert Keyword.has_key?(changeset.errors, :last_name)
    assert Keyword.has_key?(changeset.errors, :username)
    assert Keyword.has_key?(changeset.errors, :password)
  end

end
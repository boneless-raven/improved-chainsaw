defmodule Hnet.Registration.DoctorTest do
  use Hnet.ModelCase

  import Hnet.DefaultModels
  alias Hnet.Account.Registration

  @valid_attrs %{address: "Winterfell", email: "catelyn.stark@mail.com", gender: "female", 
                 first_name: "Catelyn", last_name: "Stark", phone: "1230984576",
                 username: "catstark", password: "phoenix", password_confirmation: "phoenix", 
                 doctor: %{hospital_id: nil}}
  @empty_attrs %{}

  setup do
    {:ok, hospital: create_default_hospital()}
  end

  test "changeset with valid attributes", %{hospital: hospital} do
    hospital_id = hospital.id
    params = set_hospital_id(@valid_attrs, hospital_id)
    changeset = Registration.new_doctor(params)

    assert {:ok, user} = Repo.insert(changeset)
    assert user.first_name == @valid_attrs.first_name
    assert user.last_name == @valid_attrs.last_name
    assert user.phone == @valid_attrs.phone
    assert user.email == @valid_attrs.email
    assert user.username == @valid_attrs.username
    assert user.address == @valid_attrs.address
    assert user.account_type == :doctor
    assert user.gender == :female
    assert user.password_hash
    doctor = Repo.preload user.doctor, :hospital
    assert doctor.hospital.id == hospital_id
  end

  test "changeset with invalid hospital id", %{hospital: hospital} do
    hospital_id = hospital.id
    assert {:error, changeset} = set_hospital_id(@valid_attrs, hospital_id + 1)
    |> Registration.new_doctor
    |> Repo.insert
    doctor_changeset = get_change(changeset, :doctor)
    assert Keyword.has_key?(doctor_changeset.errors, :hospital)
  end

  test "changeset with empty attributes" do
    changeset = Registration.new_doctor(@empty_attrs)
    refute changeset.valid?
    assert Keyword.has_key?(changeset.errors, :phone)
    assert Keyword.has_key?(changeset.errors, :email)
    assert Keyword.has_key?(changeset.errors, :address)
    assert Keyword.has_key?(changeset.errors, :gender)
    assert Keyword.has_key?(changeset.errors, :first_name)
    assert Keyword.has_key?(changeset.errors, :last_name)
    assert Keyword.has_key?(changeset.errors, :username)
    assert Keyword.has_key?(changeset.errors, :password)
    doctor_changeset = get_change(changeset, :doctor)
    assert Keyword.has_key?(doctor_changeset.errors, :hospital_id)
  end

  defp set_hospital_id(attrs, hospital_id) do
    Map.update!(attrs, :doctor, fn d ->
      %{d | hospital_id: hospital_id}
    end)
  end

end
defmodule Hnet.PatientTest do
  use Hnet.ModelCase

  alias Hnet.Patient

  @valid_attrs %{emergency_contact_name: "some content", emergency_contact_phone: "some content", proof_of_insurance: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Patient.changeset(%Patient{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Patient.changeset(%Patient{}, @invalid_attrs)
    refute changeset.valid?
  end
end

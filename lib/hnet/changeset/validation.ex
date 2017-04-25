defmodule Hnet.Changeset.Validation do
  @moduledoc """
  A module with various changeset validation functions.
  """
  import Ecto.Changeset

  @doc """
  Validate that the given field in the given changeset is a valid phone number.
  """
  def validate_phone(changeset, field) do
    validate_format(changeset, field, ~r/^[0-9]{10}$/)
  end

  @doc """
  Validate that the given field in the given changeset is a valid email address.
  """
  def validate_email(changeset, field) do
    validate_format(changeset, field, ~r/^[\w\d\.]+@[\w\d]+\.[\w\d]+$/)
  end
end
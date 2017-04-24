defmodule Hnet.Changeset.Validation do
  import Ecto.Changeset

  def validate_phone(changeset, field) do
    validate_format(changeset, field, ~r/^[0-9]{10}$/)
  end

  def validate_email(changeset, field) do
    validate_format(changeset, field, ~r/^[\w\d\.]+@[\w\d]+\.[\w\d]+$/)
  end
end
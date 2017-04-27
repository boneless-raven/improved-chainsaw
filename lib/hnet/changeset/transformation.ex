defmodule Hnet.Changeset.Transformation do
  import Ecto.Changeset

  @doc """
  Transform the string in the given field into all lowercase.
  
  Will raise if the given field doesn't exist or is `nil`.
  """
  def to_lowercase(changeset, field) do
    put_change(changeset, field, String.downcase(get_change(changeset, field)))
  end

  @doc """
  Trim the whitespaces of the string in the given field.

  Will raise if the given field doesn't exist or is `nil`.
  """
  def trim(changeset, field) do
    put_change(changeset, field, String.trim(get_change(changeset, field)))
  end
end
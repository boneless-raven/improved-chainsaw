defmodule Hnet.Changeset.Transformation do
  import Ecto.Changeset

  @doc """
  Transform the string in the given field into all lowercase.
  
  Will raise if the given field doesn't exist or is `nil`.
  """
  def to_lowercase(changeset, field) do
    transform(changeset, field, &String.downcase/1)
  end

  @doc """
  Trim the whitespaces of the string in the given field.

  Will raise if the given field doesn't exist or is `nil`.
  """
  def trim(changeset, field) do
    transform(changeset, field, &String.trim/1)
  end

  defp transform(changeset, field, transformation) do
    value = get_change(changeset, field)
    if value do
      put_change(changeset, field, transformation.(value))
    else
      changeset
    end
  end
end
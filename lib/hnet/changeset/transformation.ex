defmodule Hnet.Changeset.Transformation do
  import Ecto.Changeset

  def to_lowercase(changeset, field) do
    update_change(changeset, field, fn value -> String.downcase(value) end)
  end
end
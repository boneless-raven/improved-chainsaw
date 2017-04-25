defmodule Hnet.Helpers.Map do
  @moduledoc """
  A module with some helper functions for operating Elixir `Map`s.
  """

  @doc """
  Retrieve the value associated with the given `key` from the given `map`. 
  The `key` should be an `atom`;
  the first attempt will use the `key` as is.
  If no value is found, 
  then a second attempt will be made
  with the `key` being transformed into a string.
  """
  def retrieve(map, key, default \\ nil) when is_atom(key) do
    Map.get(map, key, Map.get(map, to_string(key), default))
  end
end
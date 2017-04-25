defmodule Hnet.Helpers.Map do
  def retrieve(map, key, default \\ nil) when is_atom(key) do
    Map.get(map, key, Map.get(map, to_string(key), default))
  end
end
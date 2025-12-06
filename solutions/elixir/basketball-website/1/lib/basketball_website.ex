defmodule BasketballWebsite do
  @spec extract_from_path(map, binary) :: any
  def extract_from_path(data, path) do
    keys = path |> fetch_keys()
    data |> do_extract_from_path(keys)
  end

  defp fetch_keys(path), do: path |> String.split(".")
  defp do_extract_from_path(nil, _), do: nil
  defp do_extract_from_path(data, []), do: data
  defp do_extract_from_path(data, [head | tail]), do: do_extract_from_path(data[head], tail)

  @spec get_in_path(any, binary) :: any
  def get_in_path(data, path), do: data |> get_in(path |> fetch_keys())
end

# credo:disable-for-this-file

defmodule BasketballWebsite do
  @spec extract_from_path(map(), String.t()) :: any()
  def extract_from_path(data, path) do
    path
    |> fetch_keys()
    |> do_extract_from_path(data)
  end

  defp fetch_keys(path), do: path |> String.split(".")

  defp do_extract_from_path(_, nil), do: nil
  defp do_extract_from_path([], data), do: data
  defp do_extract_from_path([head | tail], data), do: do_extract_from_path(tail, data[head])

  @spec get_in_path(any, binary) :: any
  def get_in_path(data, path), do: get_in(data, fetch_keys(path))
end

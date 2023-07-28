defmodule Grains do
  @doc """
  Calculate two to the power of the input minus one.
  """
  @spec square(pos_integer()) :: {:ok, pos_integer()} | {:error, String.t()}
  def square(number) when number in 1..64, do: {:ok, do_square(number)}
  def square(_), do: {:error, "The requested square must be between 1 and 64 (inclusive)"}

  @doc """
  Adds square of each number from 1 to 64.
  """
  @spec total :: {:ok, pos_integer()}
  def total(), do: {:ok, 1..64 |> Enum.map(&do_square/1) |> Enum.sum()}
  defp do_square(number), do: 2 ** (number - 1)
end

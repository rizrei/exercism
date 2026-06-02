defmodule Triplet do
  @doc """
  Calculates sum of a given triplet of integers.
  """
  @spec sum([non_neg_integer()]) :: non_neg_integer()
  def sum(triplet), do: Enum.sum(triplet)

  @doc """
  Calculates product of a given triplet of integers.
  """
  @spec product([non_neg_integer()]) :: non_neg_integer()
  def product(triplet), do: Enum.product(triplet)

  @doc """
  Determines if a given triplet is pythagorean. That is, do the squares of a and b add up to the square of c?
  """
  @spec pythagorean?([non_neg_integer()]) :: boolean()
  def pythagorean?([a, b, c]), do: a * a + b * b == c * c

  @doc """
  Generates a list of pythagorean triplets whose values add up to a given sum.
  """
  @spec generate(non_neg_integer()) :: [list(non_neg_integer())]
  def generate(total) do
    for a <- 1..div(total, 3),
        rem(total * (total - 2 * a), 2 * (total - a)) == 0,
        b = div(total * (total - 2 * a), 2 * (total - a)),
        c = total - a - b,
        a < b and b < c do
      [a, b, c]
    end
  end
end

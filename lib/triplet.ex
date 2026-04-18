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
    # max_a is the largest possible value for a in a triplet that sums to total, since a < b < c and a + b + c = total
    # a + (a + 1) + (a + 2) = total
    # 3a + 3 = total
    # a ≤ (total - 3) / 3
    # max_b is the largest possible value for b in a triplet that sums to total, given a, since b < c and a + b + c = total
    # b < total - a - b
    # 2b < total - a
    # b < (total - a) / 2
    max_a = div(total - 1, 3)

    for a <- 1..max_a,
        max_b = div(total - a - 1, 2),
        b <- (a + 1)..max(a + 1, max_b),
        c = total - a - b,
        c > b and pythagorean?([a, b, c]) do
      [a, b, c]
    end
  end
end

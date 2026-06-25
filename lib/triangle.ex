defmodule Triangle do
  defguard is_positive_sides(a, b, c) when a > 0 and b > 0 and c > 0
  defguard is_valid_triangle(a, b, c) when abs(a - b) < c and c < a + b

  @type kind :: :equilateral | :isosceles | :scalene

  @errors %{
    triangle_inequality: "side lengths violate triangle inequality",
    negative_side_length: "all side lengths must be positive"
  }

  @moduledoc """
  Return the kind of triangle of a triangle with 'a', 'b' and 'c' as lengths.
  """
  @spec kind(number(), number(), number()) :: {:ok, kind()} | {:error, String.t()}
  def kind(a, b, c) when not is_positive_sides(a, b, c),
    do: {:error, @errors[:negative_side_length]}

  def kind(a, b, c) when not is_valid_triangle(a, b, c),
    do: {:error, @errors[:triangle_inequality]}

  def kind(a, a, a), do: {:ok, :equilateral}
  def kind(a, a, _), do: {:ok, :isosceles}
  def kind(_, a, a), do: {:ok, :isosceles}
  def kind(a, _, a), do: {:ok, :isosceles}
  def kind(_, _, _), do: {:ok, :scalene}
end

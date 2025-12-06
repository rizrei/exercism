defmodule Triangle do
  @type kind :: :equilateral | :isosceles | :scalene

  @triangle_inequality_error "side lengths violate triangle inequality"
  @negative_side_length_error "all side lengths must be positive"

  @doc """
  Return the kind of triangle of a triangle with 'a', 'b' and 'c' as lengths.
  """
  @spec kind(number, number, number) :: {:ok, kind} | {:error, String.t()}
  def kind(a, b, c) when a * b * c <= 0, do: {:error, @negative_side_length_error}

  def kind(a, b, c) when not (abs(a - b) < c and c < a + b),
    do: {:error, @triangle_inequality_error}

  def kind(a, a, a), do: {:ok, :equilateral}
  def kind(a, a, _), do: {:ok, :isosceles}
  def kind(_, a, a), do: {:ok, :isosceles}
  def kind(a, _, a), do: {:ok, :isosceles}
  def kind(_, _, _), do: {:ok, :scalene}
end
defmodule RationalNumbers do
  @type rational :: {integer, integer}

  @doc """
  Add two rational numbers
  """
  @spec add(a :: rational, b :: rational) :: rational
  def add({n1, d1}, {n2, d2}) do
    {n1 * d2 + n2 * d1, d1 * d2} |> reduce()
  end

  @doc """
  Subtract two rational numbers
  """
  @spec subtract(a :: rational, b :: rational) :: rational
  def subtract({n1, d1}, {n2, d2}) do
    {n1 * d2 - n2 * d1, d1 * d2} |> reduce()
  end

  @doc """
  Multiply two rational numbers
  """
  @spec multiply(a :: rational, b :: rational) :: rational
  def multiply({n1, d1}, {n2, d2}) do
    {n1 * n2, d1 * d2} |> reduce()
  end

  @doc """
  Divide two rational numbers
  """
  @spec divide_by(num :: rational, den :: rational) :: rational
  def divide_by({n1, d1}, {n2, d2}), do: {n1 * d2, d1 * n2} |> reduce()

  @doc """
  Absolute value of a rational number
  """
  @spec abs(a :: rational) :: rational
  def abs({n, d}), do: {n |> Kernel.abs(), d |> Kernel.abs()} |> reduce()

  @doc """
  Exponentiation of a rational number by an integer
  """
  @spec pow_rational(a :: rational, n :: integer) :: rational
  # def pow_rational(_, 0), do: {1, 1}
  # def pow_rational(rational, 1), do: rational
  def pow_rational({n, d}, m) when m < 0, do: pow_rational({d, n}, Kernel.abs(m))
  def pow_rational({n, d}, m) do
    # rational |> multiply(rational) |> pow_rational(m-1)
    {:math.pow(n, m) |> trunc(), :math.pow(d, m) |> trunc()} |> reduce()
  end

  @doc """
  Exponentiation of a real number by a rational number
  """
  @spec pow_real(x :: integer, n :: rational) :: float
  def pow_real(x, {n, d}) do
    x |> :math.pow(n) |> :math.log |> Kernel./(d) |> :math.exp()
  end

  @doc """
  Reduce a rational number to its lowest terms
  """
  @spec reduce(a :: rational) :: rational
  def reduce({n, d}) do
    gcd = Integer.gcd(trunc(n), trunc(d))
    {n |> Kernel./(gcd) |> trunc(), d |> Kernel./(gcd) |> trunc()} |> format()
  end

  defp format({n, d}) when (n > 0 and d < 0) or (n < 0 and d < 0), do: {-n, -d}
  defp format(rational), do: rational
end

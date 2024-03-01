defmodule ComplexNumbers do
  @typedoc """
  In this module, complex numbers are represented as a tuple-pair containing the real and
  imaginary parts.
  For example, the real number `1` is `{1, 0}`, the imaginary number `i` is `{0, 1}` and
  the complex number `4+3i` is `{4, 3}'.
  """
  @type complex :: {float, float}

  @doc """
  Return the real part of a complex number
  """
  @spec real(a :: complex) :: float
  def real({r, _}), do: r
  def real(a), do: a

  @doc """
  Return the imaginary part of a complex number
  """
  @spec imaginary(a :: complex) :: float
  def imaginary({_, i}), do: i
  def imaginary(a), do: a

  @doc """
  Multiply two complex numbers, or a real and a complex number
  """

  @spec mul(a :: complex | float, b :: complex | float) :: complex
  def mul({r1, i1}, {r2, i2}), do: {r1 * r2 - i1 * i2, i1 * r2 + r1 * i2}
  def mul(a, b), do: mul(to_complex(a), to_complex(b))

  @doc """
  Add two complex numbers, or a real and a complex number
  """
  @spec add(a :: complex | float, b :: complex | float) :: complex
  def add({r1, i1}, {r2, i2}), do: {r1 + r2, i1 + i2}
  def add(a, b), do: add(to_complex(a), to_complex(b))

  @doc """
  Subtract two complex numbers, or a real and a complex number
  """
  @spec sub(a :: complex | float, b :: complex | float) :: complex
  def sub({r1, i1}, {r2, i2}), do: {r1 - r2, i1 - i2}
  def sub(a, b), do: sub(to_complex(a), to_complex(b))

  @doc """
  Divide two complex numbers, or a real and a complex number
  """
  @spec div(a :: complex | float, b :: complex | float) :: complex
  def div({r1, i1}, {r2, i2}) do
    {
      (r1 * r2 + i1 * i2) / (r2 ** 2 + i2 ** 2),
      (i1 * r2 - r1 * i2) / (r2 ** 2 + i2 ** 2)
    }
  end

  def div(a, b), do: ComplexNumbers.div(to_complex(a), to_complex(b))

  @doc """
  Absolute value of a complex number
  """
  @spec abs(a :: complex) :: float
  def abs({r, i}), do: :math.sqrt(r ** 2 + i ** 2)

  @doc """
  Conjugate of a complex number
  """
  @spec conjugate(a :: complex) :: complex
  def conjugate({r, i}), do: {r, -i}

  @doc """
  Exponential of a complex number
  """
  @spec exp(a :: complex) :: complex
  def exp(a) do
    {r, i} = {real(a), imaginary(a)}

    {:math.exp(r) * :math.cos(i), :math.exp(r) * :math.sin(i)}
  end

  defp to_complex({_, _} = a), do: a
  defp to_complex(a), do: {a, 0}
end

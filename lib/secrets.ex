defmodule Secrets do
  @spec secret_add(integer) :: (integer -> integer)
  def secret_add(secret), do: &(&1 + secret)

  @spec secret_subtract(integer) :: (integer -> integer)
  def secret_subtract(secret), do: &(&1 - secret)

  @spec secret_multiply(integer) :: (integer -> integer)
  def secret_multiply(secret), do: &(&1 * secret)

  @spec secret_divide(integer) :: (integer -> integer)
  def secret_divide(secret), do: &trunc(&1 / secret)

  @spec secret_and(integer) :: (integer -> integer)
  def secret_and(secret), do: &(&1 |> Bitwise.band(secret))

  @spec secret_xor(integer) :: (integer -> integer)
  def secret_xor(secret), do: &(&1 |> Bitwise.bxor(secret))

  @spec secret_combine(integer, integer) :: (integer -> integer)
  def secret_combine(secret_function1, secret_function2) do
    &(&1 |> secret_function1.() |> secret_function2.())
  end
end

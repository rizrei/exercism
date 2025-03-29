# credo:disable-for-this-file

defmodule GuessingGame do
  @spec compare(number, number) :: String.t()
  def compare(_, :no_guess), do: "Make a guess"
  def compare(secret_number, guess) when secret_number in [guess + 1, guess - 1], do: "So close"
  def compare(secret_number, guess) when secret_number < guess, do: "Too high"
  def compare(secret_number, guess) when secret_number > guess, do: "Too low"
  def compare(secret_number, guess) when secret_number == guess, do: "Correct"
end

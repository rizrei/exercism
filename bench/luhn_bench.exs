defmodule Luhn1 do
  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number) do
    number =~ ~r/^[\d\s]+$/ and
      Regex.scan(~r/\d/, number)
      |> Enum.reduce([], fn [i], acc -> [String.to_integer(i) | acc] end)
      |> Enum.with_index()
      |> Enum.map(fn {n, i} -> if rem(i, 2) == 1, do: n * 2, else: n end)
      |> Enum.map(fn n -> if n > 9, do: n - 9, else: n end)
      |> (fn lst -> Enum.count(lst) > 1 and rem(Enum.sum(lst), 10) == 0 end).()
  end
end

defmodule Luhn2 do
  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number) do
    number = String.replace(number, " ", "")

    cond do
      String.match?(number, ~r/[^0-9]/) -> false
      String.length(number) <= 1 -> false
      true -> luhn(number)
    end
  end

  defp luhn(number) do
    checksum =
      (number <> "0")
      |> to_charlist
      |> Enum.reverse()
      |> Enum.map(fn char -> char - ?0 end)
      |> Enum.map_every(2, fn
        n when n <= 4 -> 2 * n
        n -> 2 * n - 9
      end)
      |> Enum.sum()

    rem(checksum, 10) == 0
  end
end

test_fun = fn module, function_name, input ->
  Enum.each(1..1000, fn _ -> apply(module, function_name, input) end)
end

Benchee.run(
  %{
    "Luhn" => fn input -> test_fun.(Luhn, :valid?, input) end,
    "Luhn1" => fn input -> test_fun.(Luhn1, :valid?, input) end,
    "Luhn2" => fn input -> test_fun.(Luhn2, :valid?, input) end,
  },
  memory_time: 2,
  inputs: %{
    "Small" => ["055 444 285"],
    "Medium" => ["1 2345 6789 1234 5678 9013"],
    "Bigger" =>
      ["1346187461658613540570167406016456104600460914096904760416061405610465016460146004601460943760910469610961430564"]
  }
)

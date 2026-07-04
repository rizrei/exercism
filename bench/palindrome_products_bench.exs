defmodule PalindromeProducts1 do
  @doc """
  Generates all palindrome products from an optionally given min factor (or 1) to a given max factor.
  """

  @spec generate(non_neg_integer(), non_neg_integer()) :: map()
  def generate(max_factor, min_factor \\ 1)
  def generate(max, min) when min > max, do: raise(ArgumentError)

  def generate(max_factor, min_factor) do
    for x <- min_factor..max_factor,
        y <- x..max_factor,
        product = x * y,
        palindrome?(product),
        reduce: %{} do
      acc -> Map.update(acc, product, [[x, y]], &[[x, y] | &1])
    end
  end

  defp palindrome?(n), do: palindrome?(n, 0, n)
  defp palindrome?(0, rev, original), do: rev == original
  defp palindrome?(n, rev, original), do: palindrome?(div(n, 10), rev * 10 + rem(n, 10), original)
end

defmodule PalindromeProductsIteration2 do
  def generate(max_factor, min_factor \\ 1)
  def generate(max_factor, min_factor) when min_factor > max_factor,
    do: raise(ArgumentError, "min_factor must be less than or equal to max_factor")
  def generate(max_factor, min_factor),
    do: palindromes(max_factor, min_factor)|> Enum.reverse()|> Enum.group_by(fn [f1, f2] -> f1 * f2 end)
  defp palindromes(max_factor, min_factor), do:
    for f1 <- min_factor..max_factor, f2 <- f1..max_factor, palindrome?(f1 * f2), do: [f1, f2]

  defp palindrome?(n), do: Integer.digits(n) == Enum.reverse(Integer.digits(n))
end

defmodule PalindromeProductsIteration3 do
  def generate(max_factor, min_factor \\ 1)
  def generate(max_factor, min_factor) when min_factor > max_factor,
    do: raise(ArgumentError, "min_factor must be less than or equal to max_factor")
  def generate(max_factor, min_factor) do
    for f1 <- min_factor..max_factor,
        f2 <- f1..max_factor,
        product = f1 * f2,
        palindrome?(product),
        reduce: %{} do
      acc -> Map.update(acc, product, [[f1, f2]], &[[f1, f2] | &1])
    end
  end

  defp palindrome?(n), do: n == reverse_digits(n, 0)
  defp reverse_digits(0, acc), do: acc
  defp reverse_digits(n, acc), do: reverse_digits(div(n, 10), acc * 10 + rem(n, 10))
end

defmodule PalindromeProductsS do
  @doc """
  Generates all palindrome products from an optionally given min factor (or 1) to a given max factor.

  ## Implementation notes regarding efficiency improvements:
  * palindrome?/1 via pattern-matching safes about 90% runtime of the inefficient naive implementation via Integer.to_string/1 and String.reverse/1
  * the TC-recursive generations safes about 25% runtime of the naive implementation with a for-comprehension
  * the parallel execution speeds up almost by the number of cores, as one would expect
  * On a 4-core machine, that sums up to this solution is roughly **50-60x faster** than the naive first solution
      (the slow tests took 63 seconds and now 1 second)
  """
  # Parallelize by using every scheduler, sould lead to full CPU-utilizaion
  @parallel_tasks System.schedulers() |> IO.inspect(label: "PARALLEL_TASKS USED")

  @spec generate(non_neg_integer, non_neg_integer) :: map
  def generate(max_factor, min_factor \\ 1)
  def generate(max_factor, min_factor) when max_factor >= min_factor,
    do: with(
      {:ok, mapping_agent} <- Agent.start(fn -> %{} end),
      map_fun = fn palindrome, factor_1, factor_2 -> Agent.update(mapping_agent, &add_factor_pair(&1, palindrome, factor_1, factor_2)) end,
      generator_tasks = Enum.map(0..@parallel_tasks-1, fn task_offset ->
        Task.async(fn -> map_generate(map_fun, @parallel_tasks, max_factor, min_factor+task_offset, min_factor+task_offset) end)
      end),
      [:ok |_] <- Task.await_many(generator_tasks),
      factor_pairs_by_palindrome = %{} <- Agent.get(mapping_agent, & &1),
      :ok <- Agent.stop(mapping_agent),
      do: factor_pairs_by_palindrome)

  def generate(_,_), do: raise ArgumentError

  # generator function, uses map_fun for accumulating, runs parallel with different initial values for outer factor and progresses by step
  defp map_generate(map_fun, step, upper_bound, outer_factor, inner_factor)
  defp map_generate(_, _, upper_bound, outer_factor_out, _) when outer_factor_out > upper_bound, do: :ok
  defp map_generate(map_fun, step, upper_bound, outer_factor, inner_factor_out) when inner_factor_out > upper_bound,
    do: map_generate(map_fun, step, upper_bound, outer_factor + step, outer_factor + step)
  defp map_generate(map_fun, step, upper_bound, outer_factor, inner_factor),
    do:
      with(
        product =  outer_factor * inner_factor,
        do: if(palindrome?(product), do: map_fun.(product, outer_factor, inner_factor)))
      |> then( fn _result_irrelevant_since_we_accumulate_with_map_fun ->
          map_generate(map_fun, step, upper_bound, outer_factor, inner_factor+1)
      end)

  # this is too slow: defp palindrome?(integer), do: integer == Integer.undigits(Enum.reverse(Integer.digits(integer)))
  # more efficient; could be generated via meta-programming
  defp palindrome?(n) when n <= 9, do: true
  defp palindrome?(n) when n >= 11 and n <= 99, do: equal_digits?(n, 0,1)
  defp palindrome?(n) when n >= 101 and n <= 999, do: equal_digits?(n, 0,2)
  defp palindrome?(n) when n >= 1001 and n <= 9999, do: equal_digits?(n, 0,3) && equal_digits?(n, 1,2)
  defp palindrome?(n) when n >= 10001 and n <= 99999, do: equal_digits?(n, 0,4) && equal_digits?(n, 1,3)
  defp palindrome?(n) when n >= 100001 and n <= 999999, do: equal_digits?(n, 0,5) && equal_digits?(n, 1,4) && equal_digits?(n, 2,3)
  defp palindrome?(n) when n >= 1000001 and n <= 9999999, do: equal_digits?(n, 0,6) && equal_digits?(n, 1,5)  && equal_digits?(n, 2,4)
  defp palindrome?(n) when n >= 10000001 and n <= 99999999, do: equal_digits?(n, 0,7) && equal_digits?(n, 1,6) && equal_digits?(n, 2,5) && equal_digits?(n, 3,4)
  defp palindrome?(n) when n >= 100000001 and n <= 999999999, do: equal_digits?(n, 0,8) && equal_digits?(n, 1,7)  && equal_digits?(n, 2,6) && equal_digits?(n, 3,5)
  defp palindrome?(_), do: false

  defp equal_digits?(n, dec1, dec2), do: digit(n, dec1) == digit(n, dec2)

  defp digit(n, 0), do: rem(n, 10)
  defp digit(n, 1), do: rem(div(n, 10), 10)
  defp digit(n, 2), do: rem(div(n, 100), 10)
  defp digit(n, 3), do: rem(div(n, 1000), 10)
  defp digit(n, 4), do: rem(div(n, 10000), 10)
  defp digit(n, 5), do: rem(div(n, 100000), 10)
  defp digit(n, 6), do: rem(div(n, 1000000), 10)
  defp digit(n, 7), do: rem(div(n, 10000000), 10)
  defp digit(n, 8), do: rem(div(n, 100000000), 10)

  defp add_factor_pair(factor_pairs_by_palindrome, palindrome, factor_1, factor_2),
    do: Map.update(
                factor_pairs_by_palindrome,
                palindrome,
                [[factor_1, factor_2]],
                &[[factor_1, factor_2] | &1])

end


test_fun = fn module, function_name, input ->
  # Enum.each(1..1, fn _ -> apply(module, function_name, input) end)
  apply(module, function_name, input)
end

Benchee.run(
  %{
    "Palindrome via reverse" => fn input -> test_fun.(PalindromeProductsIteration2, :generate, input) end,
    "Palindrome via div/rem" => fn input -> test_fun.(PalindromeProductsIteration3, :generate, input) end,
    "Palindrome" => fn input -> test_fun.(PalindromeProductsS, :generate, input) end,
  },
  memory_time: 2,
  parallel: 4,
  inputs: %{
    "test case 1" => [9999, 1000]
  }
)

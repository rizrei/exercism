defmodule Frequency do
  defmodule Worker do
    @letter ~r/^\p{L}$/u

    @spec run(String.t()) :: map()
    def run(text) do
      text
      |> String.downcase()
      |> String.codepoints()
      |> Enum.filter(&String.match?(&1, @letter))
      |> Enum.frequencies()
    end
  end

  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t()], pos_integer()) :: map()
  def frequency(texts, workers) do
    texts
    |> Task.async_stream(Worker, :run, [], ordered: false, max_concurrency: workers)
    |> Enum.reduce(%{}, fn {:ok, freq}, acc ->
      Map.merge(acc, freq, fn _key, v1, v2 -> v1 + v2 end)
    end)
  end
end

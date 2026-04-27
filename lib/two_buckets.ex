defmodule TwoBucket do
  defstruct [:bucket_one, :bucket_two, :moves]
  @type t() :: %TwoBucket{bucket_one: integer(), bucket_two: integer(), moves: integer()}

  @doc """
  Find the quickest way to fill a bucket with some amount of water from two buckets of specific sizes.
  """
  @spec measure(
          size_one :: integer(),
          size_two :: integer(),
          goal :: integer(),
          start_bucket :: :one | :two
        ) :: {:ok, TwoBucket.t()} | {:error, :impossible}
  def measure(b1, b2, goal, :one),
    do: do_measure(b1, b2, goal, :queue.from_list([{b1, 0, 1}]), MapSet.new([{0, b2}]))

  def measure(b1, b2, goal, :two),
    do: do_measure(b1, b2, goal, :queue.from_list([{0, b2, 1}]), MapSet.new([{b1, 0}]))

  defp do_measure(s1, s2, goal, queue, set) do
    case :queue.out(queue) do
      {:empty, _} ->
        {:error, :impossible}

      {{:value, {b1, b2, step} = variant}, t_queue} ->
        cond do
          MapSet.member?(set, {b1, b2}) ->
            do_measure(s1, s2, goal, t_queue, set)

          b1 == goal or b2 == goal ->
            {:ok, %__MODULE__{bucket_one: b1, bucket_two: b2, moves: step}}

          true ->
            do_measure(
              s1,
              s2,
              goal,
              add_variants(t_queue, s1, s2, variant),
              MapSet.put(set, {b1, b2})
            )
        end
    end
  end

  defp add_variants(queue, s1, s2, {b1, b2, step}) do
    [
      {s1, b2, step + 1},
      {b1, s2, step + 1},
      {min(b1 + b2, s1), b2 - min(b1 + b2, s1) + b1, step + 1},
      {b1 - min(b1 + b2, s2) + b2, min(b1 + b2, s2), step + 1},
      {0, b2, step + 1},
      {b1, 0, step + 1}
    ]
    |> Enum.reduce(queue, &:queue.in/2)
  end
end

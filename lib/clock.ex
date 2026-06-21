defmodule Clock do
  @type t() :: %__MODULE__{hour: integer(), minute: integer()}

  defstruct hour: 0, minute: 0

  @minutes_per_day 1440
  @minutes_per_hour 60

  @doc """
  Returns a clock that can be represented as a string:

      iex> Clock.new(8, 9) |> to_string
      "08:09"
  """
  @spec new(integer(), integer()) :: t()
  def new(hour, minute) do
    minutes_in_day = Integer.mod(hour * @minutes_per_hour + minute, @minutes_per_day)

    %Clock{
      hour: div(minutes_in_day, @minutes_per_hour),
      minute: rem(minutes_in_day, @minutes_per_hour)
    }
  end

  @doc """
  Adds two clock times:

      iex> Clock.new(10, 0) |> Clock.add(3) |> to_string
      "10:03"
  """
  @spec add(t(), integer()) :: t()
  def add(%Clock{hour: h, minute: m}, add_minute), do: new(h, m + add_minute)

  defimpl String.Chars do
    def to_string(%Clock{hour: h, minute: m}) do
      "~2..0B:~2..0B" |> :io_lib.format([h, m]) |> Kernel.to_string()
    end
  end
end

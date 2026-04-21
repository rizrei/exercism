defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """

  @type weekday ::
          :monday
          | :tuesday
          | :wednesday
          | :thursday
          | :friday
          | :saturday
          | :sunday

  @type year() :: pos_integer()
  @type month() :: pos_integer()
  @type schedule() :: :first | :second | :third | :fourth | :last | :teenth

  @weekdays %{
    :monday => 1,
    :tuesday => 2,
    :wednesday => 3,
    :thursday => 4,
    :friday => 5,
    :saturday => 6,
    :sunday => 7
  }

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(year(), month(), weekday(), schedule()) :: Date.t()

  def meetup(year, month, weekday, :last) do
    Date.new!(year, month, 1)
    |> then(&Date.range(Date.end_of_month(&1), &1, -1))
    |> do_meetup(weekday, :first)
  end

  def meetup(year, month, weekday, schedule) do
    Date.new!(year, month, 1)
    |> then(&Date.range(&1, Date.end_of_month(&1)))
    |> do_meetup(weekday, schedule)
  end

  defp do_meetup(range, weekday, schedule) do
    acc = %{dates: [], count: 0, weekday: @weekdays[weekday], schedule: schedule}

    range
    |> Enum.reduce_while(acc, &reducer/2)
    |> Map.get(:dates)
    |> List.first()
  end

  defp reducer(_, %{count: 1, schedule: :first} = acc), do: {:halt, acc}
  defp reducer(_, %{count: 2, schedule: :second} = acc), do: {:halt, acc}
  defp reducer(_, %{count: 3, schedule: :third} = acc), do: {:halt, acc}
  defp reducer(_, %{count: 4, schedule: :fourth} = acc), do: {:halt, acc}
  defp reducer(_, %{count: 1, schedule: :teenth} = acc), do: {:halt, acc}

  defp reducer(date, %{weekday: weekday, schedule: :teenth, dates: dates, count: count} = acc) do
    new_acc =
      if Date.day_of_week(date) == weekday and 13 <= date.day and date.day <= 19 do
        %{acc | dates: [date | dates], count: count + 1}
      else
        acc
      end

    {:cont, new_acc}
  end

  defp reducer(date, %{weekday: weekday, dates: dates, count: count} = acc) do
    new_acc =
      if Date.day_of_week(date) == weekday do
        %{acc | dates: [date | dates], count: count + 1}
      else
        acc
      end

    {:cont, new_acc}
  end
end

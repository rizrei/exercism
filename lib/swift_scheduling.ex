defmodule SwiftScheduling do
  @doc """
  Convert delivery date descriptions to actual delivery dates, based on when the meeting started.
  """

  @spec delivery_date(NaiveDateTime.t(), String.t()) :: NaiveDateTime.t()
  def delivery_date(date, "NOW"), do: NaiveDateTime.shift(date, hour: 2)

  def delivery_date(%{hour: h} = date, "ASAP") when h < 13, do: set_hour(date, 17)
  def delivery_date(date, "ASAP"), do: date |> NaiveDateTime.shift(day: 1) |> set_hour(13)

  def delivery_date(date, "EOW") do
    day_of_week = date |> NaiveDateTime.to_date() |> Date.day_of_week()

    {day_shift, hour} =
      if day_of_week in 1..3 do
        {5 - day_of_week, 17}
      else
        {7 - day_of_week, 20}
      end

    date |> NaiveDateTime.shift(day: day_shift) |> set_hour(hour)
  end

  def delivery_date(date, <<n::binary-size(1), "M">>) do
    do_delivery_date(date, {"M", String.to_integer(n)})
  end

  def delivery_date(date, <<n::binary-size(2), "M">>) do
    do_delivery_date(date, {"M", String.to_integer(n)})
  end

  def delivery_date(date, "Q" <> n) do
    do_delivery_date(date, {"Q", String.to_integer(n)})
  end

  defp do_delivery_date(date, {"M", month}) do
    date
    |> then(fn
      %{month: m} = date when m < month -> date
      date -> set_next_year(date)
    end)
    |> set_month_first_workday(month)
    |> set_hour(8)
  end

  defp do_delivery_date(date, {"Q", q}) do
    date
    |> then(fn
      %{month: m} = date when ceil(m / 3) <= q -> date
      date -> set_next_year(date)
    end)
    |> set_month_last_workday(q * 3)
    |> set_hour(8)
  end

  defp set_next_year(n_date_time), do: NaiveDateTime.shift(n_date_time, year: 1)
  defp set_hour(n_date_time, hour), do: %{n_date_time | hour: hour, minute: 0, second: 0}

  defp set_month_last_workday(n_date_time, month) do
    end_date = %{n_date_time | month: month} |> NaiveDateTime.to_date() |> Date.end_of_month()
    last = NaiveDateTime.new!(end_date, ~T[23:59:59])

    last
    |> NaiveDateTime.to_date()
    |> Date.day_of_week()
    |> case do
      6 -> NaiveDateTime.shift(last, day: -1)
      7 -> NaiveDateTime.shift(last, day: -2)
      _ -> last
    end
  end

  defp set_month_first_workday(n_date_time, month) do
    first = %{n_date_time | month: month, day: 1}

    first
    |> NaiveDateTime.to_date()
    |> Date.day_of_week()
    |> case do
      6 -> NaiveDateTime.shift(first, day: 2)
      7 -> NaiveDateTime.shift(first, day: 1)
      _ -> first
    end
  end
end

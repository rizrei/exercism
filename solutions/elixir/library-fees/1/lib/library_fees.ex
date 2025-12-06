defmodule LibraryFees do
  @spec datetime_from_string(binary) :: NaiveDateTime.t()
  def datetime_from_string(string) do
    {:ok, datetime} = string |> NaiveDateTime.from_iso8601()
    datetime
  end

  @spec before_noon?(NaiveDateTime.t()) :: boolean
  def before_noon?(datetime) do
    datetime |> NaiveDateTime.to_time() |> Time.compare(~T[12:00:00]) == :lt
  end

  @spec return_date(NaiveDateTime.t()) :: Date.t()
  def return_date(checkout_datetime) do
    number_of_rentaldays = number_of_rentaldays(checkout_datetime)

    checkout_datetime
    |> NaiveDateTime.add(number_of_rentaldays, :day)
    |> NaiveDateTime.to_date()
  end

  defp number_of_rentaldays(checkout_datetime) do
    if before_noon?(checkout_datetime), do: 28, else: 29
  end

  @spec days_late(Date.t(), NaiveDateTime.t()) :: integer
  def days_late(planned_return_date, actual_return_datetime) do
    diff = actual_return_datetime |> NaiveDateTime.to_date() |> Date.diff(planned_return_date)
    if diff < 0, do: 0, else: diff
  end

  @spec monday?(NaiveDateTime.t()) :: boolean
  def monday?(datetime) do
    datetime |> NaiveDateTime.to_date() |> Date.day_of_week() == 1
  end

  def calculate_late_fee(checkout, return, rate) do
    return_date = checkout |> datetime_from_string() |> return_date()
    actual_return_datetime = return |> datetime_from_string()
    days_late = return_date |> days_late(actual_return_datetime)
    fee = days_late * rate

    cond do
      days_late == 0 -> 0
      days_late > 0 and actual_return_datetime |> monday?() -> floor(fee / 2)
      true -> fee
    end
  end
end

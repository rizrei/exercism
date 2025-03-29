# credo:disable-for-this-file

defmodule LibraryFees do
  @spec datetime_from_string(binary) :: NaiveDateTime.t()
  def datetime_from_string(string), do: NaiveDateTime.from_iso8601!(string)

  @spec before_noon?(NaiveDateTime.t()) :: boolean
  def before_noon?(%NaiveDateTime{hour: hour}), do: hour < 12

  @spec return_date(NaiveDateTime.t()) :: Date.t()
  def return_date(checkout_datetime) do
    number_of_rentaldays = number_of_rental_days(checkout_datetime)

    checkout_datetime
    |> NaiveDateTime.add(number_of_rentaldays, :day)
    |> NaiveDateTime.to_date()
  end

  defp number_of_rental_days(checkout_datetime) do
    if before_noon?(checkout_datetime), do: 28, else: 29
  end

  @spec days_late(Date.t(), NaiveDateTime.t()) :: integer
  def days_late(planned_return_date, actual_return_datetime) do
    actual_return_datetime
    |> NaiveDateTime.to_date()
    |> Date.diff(planned_return_date)
    |> max(0)
  end

  @spec monday?(NaiveDateTime.t()) :: boolean
  def monday?(datetime) do
    datetime |> NaiveDateTime.to_date() |> Date.day_of_week() == 1
  end

  @spec calculate_late_fee(binary, binary, number) :: number
  def calculate_late_fee(checkout, return, rate) do
    return_date = checkout |> datetime_from_string() |> return_date()
    actual_return_datetime = return |> datetime_from_string()
    discount = actual_return_datetime |> monday?()

    return_date
    |> days_late(actual_return_datetime)
    |> Kernel.*(rate)
    |> do_calculate_late_fee(discount)
  end

  defp do_calculate_late_fee(fee, true), do: floor(fee / 2)
  defp do_calculate_late_fee(fee, _), do: fee
end

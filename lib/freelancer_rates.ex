defmodule FreelancerRates do
  @working_hours_per_day 8.0
  @billable_days 22

  @spec daily_rate(number()) :: float()
  def daily_rate(hourly_rate) do
    @working_hours_per_day * hourly_rate
  end

  @spec apply_discount(number, number) :: float
  def apply_discount(before_discount, discount) do
    before_discount - before_discount * discount / 100
  end

  def monthly_rate(hourly_rate, discount) do
    hourly_rate
    |> daily_rate()
    |> Kernel.*(@billable_days)
    |> apply_discount(discount)
    |> Float.ceil()
    |> trunc()
  end

  def days_in_budget(budget, hourly_rate, discount) do
    day_rate_with_discount =
      hourly_rate
      |> daily_rate()
      |> apply_discount(discount)

    budget |> Kernel./(day_rate_with_discount) |> Float.floor(1)
  end
end

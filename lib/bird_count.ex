# credo:disable-for-this-file

defmodule BirdCount do
  @spec today([non_neg_integer()] | []) :: non_neg_integer() | nil
  def today([]), do: nil
  def today([head | _]), do: head

  @spec increment_day_count([non_neg_integer()] | []) :: [pos_integer()]
  def increment_day_count([]), do: [1]
  def increment_day_count([head | tail]), do: [head + 1 | tail]

  @spec has_day_without_birds?([non_neg_integer()] | []) :: boolean()
  def has_day_without_birds?([]), do: false
  def has_day_without_birds?([0 | _]), do: true
  def has_day_without_birds?([_ | tail]), do: has_day_without_birds?(tail)

  @spec total([non_neg_integer()] | []) :: non_neg_integer()
  def total([]), do: 0
  def total([head | tail]), do: head + total(tail)

  @spec busy_days([non_neg_integer()] | []) :: non_neg_integer()
  def busy_days([]), do: 0
  def busy_days([head | tail]) when head >= 5, do: 1 + busy_days(tail)
  def busy_days([_ | tail]), do: busy_days(tail)
end

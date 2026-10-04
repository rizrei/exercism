# credo:disable-for-this-file

defmodule BirdCount do
  @spec today([non_neg_integer()] | []) :: non_neg_integer() | nil
  def today([]), do: nil
  def today([h | _]), do: h

  @spec increment_day_count([non_neg_integer()] | []) :: [pos_integer()]
  def increment_day_count([]), do: [1]
  def increment_day_count([h | t]), do: [h + 1 | t]

  @spec has_day_without_birds?([non_neg_integer()] | []) :: boolean()
  def has_day_without_birds?([]), do: false
  def has_day_without_birds?([0 | _]), do: true
  def has_day_without_birds?([_ | t]), do: has_day_without_birds?(t)

  @spec total([non_neg_integer()] | []) :: non_neg_integer()
  def total(list), do: do_total(list, 0)

  defp do_total([], sum), do: sum
  defp do_total([h | t], sum), do: do_total(t, h + sum)

  @spec busy_days([non_neg_integer()] | []) :: non_neg_integer()
  def busy_days(list), do: do_busy_days(list, 0)

  defp do_busy_days([], count), do: count
  defp do_busy_days([h | t], count) when h < 5, do: do_busy_days(t, count)
  defp do_busy_days([_ | tail], count), do: do_busy_days(tail, count + 1)
end

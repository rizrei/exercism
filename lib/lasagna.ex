# credo:disable-for-this-file

defmodule Lasagna do
  @expected_minutes_in_oven 40
  @minutes_to_each_layear 20

  @spec expected_minutes_in_oven :: 40
  def expected_minutes_in_oven, do: @expected_minutes_in_oven

  @spec remaining_minutes_in_oven(number) :: number
  def remaining_minutes_in_oven(minutes_in_oven) do
    @expected_minutes_in_oven - minutes_in_oven
  end

  @spec preparation_time_in_minutes(number) :: number
  def preparation_time_in_minutes(number_of_layers) do
    @minutes_to_each_layear * number_of_layers
  end

  @spec total_time_in_minutes(number, number) :: number
  def total_time_in_minutes(number_of_layers, minutes_in_oven) do
    preparation_time_in_minutes(number_of_layers) + minutes_in_oven
  end

  @spec alarm :: String.t()
  def alarm, do: "Ding!"
end

defmodule Darts do
  @outer_circle_radius 10
  @middle_circle_radius 5
  @inner_circle_radius 1

  @doc """
  Calculate the score of a single dart hitting a target
  """
  @type position :: {number, number}
  @spec score(position) :: integer
  def score({x, y}) do
    position_radius = :math.sqrt(:math.pow(x, 2) + :math.pow(y, 2))

    cond do
      position_radius <= @inner_circle_radius -> 10
      position_radius <= @middle_circle_radius -> 5
      position_radius <= @outer_circle_radius -> 1
      true -> 0
    end
  end
end

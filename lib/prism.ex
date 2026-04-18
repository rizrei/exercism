defmodule Prism do
  @doc """
  Finds the sequence of prisms that the laser will hit.
  """

  @type start :: %{angle: number(), x: number(), y: number()}
  @type prism :: %{id: integer(), angle: number(), x: number(), y: number()}

  @tolerance 1.0e-4
  @radians_conversion :math.pi() / 180

  @spec find_sequence(prisms :: [prism()], start :: start()) :: [integer()]
  def find_sequence(prism_list, start), do: find_sequence(prism_list, start, [])

  defp find_sequence(prism_list, start, acc) do
    case find_next_prism(prism_list, start) do
      %{id: id, angle: angle, x: x, y: y} ->
        find_sequence(prism_list, %{angle: angle + start.angle, x: x, y: y}, [id | acc])

      nil ->
        Enum.reverse(acc)
    end
  end

  defp find_next_prism(prism_list, start) do
    prism_list
    |> Enum.filter(&on_beam?(&1, start))
    |> Enum.min_by(&distance_from(&1, start), fn -> nil end)
  end

  defp on_beam?(prism, start) do
    dy = prism.y - start.y
    dx = prism.x - start.x
    distance = :math.sqrt(dx * dx + dy * dy)

    if distance == 0.0 do
      false
    else
      beam_angle_rad = start.angle * @radians_conversion
      sin_diff = abs(:math.sin(beam_angle_rad) - dy / distance)
      cos_diff = abs(:math.cos(beam_angle_rad) - dx / distance)
      sin_diff <= @tolerance and cos_diff <= @tolerance
    end
  end

  defp distance_from(prism, start) do
    dx = prism.x - start.x
    dy = prism.y - start.y
    dx * dx + dy * dy
  end
end

defmodule Garden do
  @moduledoc """
    Accepts a string representing the arrangement of cups on a windowsill and a
    list with names of students in the class. The student names list does not
    have to be in alphabetical order.

    It decodes that string into the various gardens for each student and returns
    that information in a map.
  """

  @student_names [
    :alice,
    :bob,
    :charlie,
    :david,
    :eve,
    :fred,
    :ginny,
    :harriet,
    :ileana,
    :joseph,
    :kincaid,
    :larry
  ]
  @plants %{"C" => :clover, "G" => :grass, "R" => :radishes, "V" => :violets}

  @spec info(String.t(), [atom()]) :: map()
  def info(info_string, student_names \\ @student_names) do
    plants =
      info_string
      |> String.split("\n")
      |> Enum.map(&cups_mappeer/1)
      |> Enum.zip()
      |> Enum.map(fn {x, y} -> List.to_tuple(x ++ y) end)

    student_names
    |> Enum.sort()
    |> Enum.with_index()
    |> Enum.map(fn {name, index} -> {name, Enum.at(plants, index, {})} end)
    |> Map.new()
  end

  def cups_mappeer(cup) do
    cup |> String.graphemes() |> Enum.map(&Map.get(@plants, &1)) |> Enum.chunk_every(2)
  end
end

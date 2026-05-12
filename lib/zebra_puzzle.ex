defmodule ZebraPuzzle do
  defmodule House do
    defstruct [:number, :color, :nation, :drink, :hobbies, :pet]
  end

  @colors [:blue, :green, :yellow, :red, :ivory]
  @drinks [:water, :tea, :milk, :orange_juice, :coffee]
  @nations [:norwegian, :ukrainian, :englishman, :spaniard, :japanese]
  @pets [:fox, :horse, :snail, :dog, :zebra]
  @hobbies [:dancing, :painting, :reading, :football, :chess]

  @doc """
  Determine who drinks the water
  """
  @spec drinks_water() :: atom()
  def drinks_water() do
    result()
    |> Enum.find(&(&1.drink == :water))
    |> then(& &1.nation)
  end

  @doc """
  Determine who owns the zebra
  """
  @spec owns_zebra() :: atom()
  def owns_zebra() do
    result()
    |> Enum.find(&(&1.pet == :zebra))
    |> then(& &1.nation)
  end

  defp result do
    for nations <- permutations(@nations),
        rule10(nations),
        colors <- permutations(@colors),
        rule6(colors),
        rule2(nations, colors),
        rule15(nations, colors),
        pets <- permutations(@pets),
        rule3(nations, pets),
        drinks <- permutations(@drinks),
        rule9(drinks),
        rule5(nations, drinks),
        rule4(colors, drinks),
        hobbies <- permutations(@hobbies),
        rule7(hobbies, pets),
        rule11(hobbies, pets),
        rule12(hobbies, pets),
        rule8(colors, hobbies),
        rule13(hobbies, drinks),
        rule14(nations, hobbies) do
      Enum.zip_with([1..5, colors, nations, drinks, hobbies, pets], &build_house/1)
    end
    |> List.flatten()
  end

  defp permutations([]), do: [[]]

  defp permutations(list) do
    for elem <- list, rest <- permutations(list -- [elem]), do: [elem | rest]
  end

  defp build_house([number, color, nation, drink, hobbies, pet]) do
    %House{number: number, color: color, nation: nation, drink: drink, hobbies: hobbies, pet: pet}
  end

  # The Englishman lives in the red house.
  defp rule2(nations, colors) do
    Enum.find_index(nations, &(&1 == :englishman)) == Enum.find_index(colors, &(&1 == :red))
  end

  # The Spaniard owns the dog.
  defp rule3(nations, pets) do
    Enum.find_index(nations, &(&1 == :spaniard)) == Enum.find_index(pets, &(&1 == :dog))
  end

  # The person in the green house drinks coffee.
  defp rule4(colors, drinks) do
    Enum.find_index(colors, &(&1 == :green)) == Enum.find_index(drinks, &(&1 == :coffee))
  end

  # The Ukrainian drinks tea.
  defp rule5(nations, drinks) do
    Enum.find_index(nations, &(&1 == :ukrainian)) == Enum.find_index(drinks, &(&1 == :tea))
  end

  # The green house is immediately to the right of the ivory house.
  defp rule6(colors) do
    Enum.at(colors, Enum.find_index(colors, &(&1 == :ivory)) + 1) == :green
  end

  # The snail owner likes to go dancing.
  defp rule7(hobbies, pets) do
    Enum.find_index(pets, &(&1 == :snail)) == Enum.find_index(hobbies, &(&1 == :dancing))
  end

  # The person in the yellow house is a painter.
  defp rule8(colors, hobbies) do
    Enum.find_index(colors, &(&1 == :yellow)) == Enum.find_index(hobbies, &(&1 == :painting))
  end

  # The person in the middle house drinks milk.
  defp rule9(drinks) do
    Enum.at(drinks, 2) == :milk
  end

  # The Norwegian lives in the first house.
  defp rule10(nations) do
    hd(nations) == :norwegian
  end

  # The person who enjoys reading lives in the house next to the person with the fox.
  defp rule11(hobbies, pets) do
    diff = Enum.find_index(pets, &(&1 == :fox)) - Enum.find_index(hobbies, &(&1 == :reading))
    abs(diff) == 1
  end

  # The painter's house is next to the house with the horse.
  defp rule12(hobbies, pets) do
    diff = Enum.find_index(pets, &(&1 == :horse)) - Enum.find_index(hobbies, &(&1 == :painting))
    abs(diff) == 1
  end

  # The person who plays football drinks orange juice.
  defp rule13(hobbies, drinks) do
    Enum.find_index(hobbies, &(&1 == :football)) ==
      Enum.find_index(drinks, &(&1 == :orange_juice))
  end

  # The Japanese person plays chess.
  defp rule14(nations, hobbies) do
    Enum.find_index(nations, &(&1 == :japanese)) == Enum.find_index(hobbies, &(&1 == :chess))
  end

  # The Norwegian lives next to the blue house.
  defp rule15(nations, colors) do
    diff = Enum.find_index(nations, &(&1 == :norwegian)) - Enum.find_index(colors, &(&1 == :blue))
    abs(diff) == 1
  end
end

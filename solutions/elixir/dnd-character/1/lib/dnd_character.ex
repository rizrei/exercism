defmodule DndCharacter do
  @type t :: %__MODULE__{
          strength: pos_integer(),
          dexterity: pos_integer(),
          constitution: pos_integer(),
          intelligence: pos_integer(),
          wisdom: pos_integer(),
          charisma: pos_integer(),
          hitpoints: pos_integer()
        }

  defstruct ~w[strength dexterity constitution intelligence wisdom charisma hitpoints]a

  @spec modifier(pos_integer()) :: integer()
  def modifier(score), do: floor((score - 10) / 2)

  @spec ability :: pos_integer()
  def ability do
    1..6 |> Enum.take_random(4) |> Enum.sort() |> List.delete_at(0) |> Enum.sum()
  end

  @spec character :: t()
  def character do
    character = %__MODULE__{
      strength: ability(),
      dexterity: ability(),
      constitution: ability(),
      intelligence: ability(),
      wisdom: ability(),
      charisma: ability()
    }

    %{character | hitpoints: 10 + modifier(character.constitution)}
  end
end

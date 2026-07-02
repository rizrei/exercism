defmodule Bowling.Frame.Status do
  @enforce_keys [:type, :bonus]
  defstruct [:type, :bonus]

  @type bonus() :: 0..2
  @opaque t() :: %__MODULE__{type: :strike | :spare | :open, bonus: bonus()}

  @spec strike() :: t()
  def strike, do: %__MODULE__{type: :strike, bonus: 2}

  @spec spare() :: t()
  def spare, do: %__MODULE__{type: :spare, bonus: 1}

  @spec open() :: t()
  def open, do: %__MODULE__{type: :open, bonus: 0}
end

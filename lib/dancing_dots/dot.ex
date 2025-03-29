# credo:disable-for-this-file

defmodule DancingDots.Dot do
  defstruct [:x, :y, :radius, :opacity]
  @type t :: %__MODULE__{}
end

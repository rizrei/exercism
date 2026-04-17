defmodule RobotSimulator do
  defmodule Robot do
    defstruct position: {0, 0}, direction: :north

    @type direction() :: :north | :east | :south | :west
    @type position() :: {integer(), integer()}
    @type t() :: %__MODULE__{position: position(), direction: direction()}

    @directions [:north, :east, :south, :west]
    @rotate_right %{north: :east, east: :south, south: :west, west: :north}
    @rotate_left %{north: :west, east: :north, south: :east, west: :south}
    @advances %{north: {0, 1}, east: {1, 0}, south: {0, -1}, west: {-1, 0}}

    @spec new(direction(), position()) :: t() | {:error, String.t()}
    def new(direction, position) do
      with {:ok, position} <- validate_position(position),
           {:ok, direction} <- validate_direction(direction) do
        %__MODULE__{position: position, direction: direction}
      end
    end

    @spec execute(Robot.t(), String.t()) :: t() | {:error, String.t()}
    def execute(%Robot{direction: dir} = r, "R"), do: %{r | direction: @rotate_right[dir]}
    def execute(%Robot{direction: dir} = r, "L"), do: %{r | direction: @rotate_left[dir]}

    def execute(%Robot{direction: dir, position: {x, y}} = r, "A") do
      %{r | position: position_advance({x, y}, @advances[dir])}
    end

    def execute(_, _), do: {:error, "invalid instruction"}

    defp validate_direction(direction) when direction in @directions, do: {:ok, direction}
    defp validate_direction(_), do: {:error, "invalid direction"}

    defp validate_position({x, y}) when is_integer(x) and is_integer(y), do: {:ok, {x, y}}
    defp validate_position(_), do: {:error, "invalid position"}

    defp position_advance({x, y}, {dx, dy}), do: {x + dx, y + dy}
  end

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create() :: Robot.t()
  def create, do: %Robot{}

  @spec create(Robot.direction(), Robot.position()) :: Robot.t() | {:error, String.t()}
  def create(direction, position), do: Robot.new(direction, position)

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(Robot.t(), String.t()) :: Robot.t() | {:error, String.t()}
  def simulate(robot, instructions) do
    instructions
    |> String.graphemes()
    |> Enum.reduce_while(robot, fn instruction, acc ->
      case Robot.execute(acc, instruction) do
        {:error, _} = error -> {:halt, error}
        new_robot -> {:cont, new_robot}
      end
    end)
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(Robot.t()) :: Robot.direction()
  def direction(%Robot{direction: direction}), do: direction

  @doc """
  Return the robot's position.
  """
  @spec position(Robot.t()) :: Robot.position()
  def position(%Robot{position: position}), do: position
end

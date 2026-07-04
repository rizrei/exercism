defmodule RobotSimulator do
  defmodule Robot do
    @enforce_keys [:position, :direction]
    defstruct [:position, :direction]

    @type direction() :: :north | :east | :south | :west
    @type position() :: {integer(), integer()}
    @type t() :: %__MODULE__{position: position(), direction: direction()}

    @directions [:north, :east, :south, :west]
    @rotate_right %{north: :east, east: :south, south: :west, west: :north}
    @rotate_left %{north: :west, east: :north, south: :east, west: :south}
    @advances %{north: {0, 1}, east: {1, 0}, south: {0, -1}, west: {-1, 0}}

    @spec new(direction(), position()) :: t() | {:error, String.t()}
    def new(direction \\ :north, position \\ {0, 0}) do
      with {:ok, position} <- build_position(position),
           {:ok, direction} <- build_direction(direction) do
        %__MODULE__{position: position, direction: direction}
      end
    end

    @spec execute(Robot.t(), String.t()) :: {:ok, t()} | {:error, String.t()}
    def execute(%{direction: dir} = r, "R"), do: {:ok, %{r | direction: @rotate_right[dir]}}
    def execute(%{direction: dir} = r, "L"), do: {:ok, %{r | direction: @rotate_left[dir]}}

    def execute(%{direction: dir, position: position} = r, "A") do
      {:ok, %{r | position: position_advance(position, @advances[dir])}}
    end

    def execute(_, _), do: {:error, "invalid instruction"}

    defp build_direction(direction) when direction in @directions, do: {:ok, direction}
    defp build_direction(_), do: {:error, "invalid direction"}

    defp build_position({x, y}) when is_integer(x) and is_integer(y), do: {:ok, {x, y}}
    defp build_position(_), do: {:error, "invalid position"}

    defp position_advance({x, y}, {dx, dy}), do: {x + dx, y + dy}
  end

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create() :: Robot.t()
  def create, do: Robot.new()

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
        {:ok, new_robot} -> {:cont, new_robot}
        {:error, _} = error -> {:halt, error}
      end
    end)
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(Robot.t()) :: Robot.direction()
  def direction(robot), do: robot.direction

  @doc """
  Return the robot's position.
  """
  @spec position(Robot.t()) :: Robot.position()
  def position(robot), do: robot.position
end

# credo:disable-for-this-file

# Use the Plot struct as it is provided
defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]

  @type plot_id() :: pos_integer()
  @type registered_to() :: String.t()
  @type t() :: %__MODULE__{plot_id: plot_id(), registered_to: registered_to()}

  @spec new(plot_id(), registered_to()) :: t()
  def new(plot_id, registered_to), do: %__MODULE__{plot_id: plot_id, registered_to: registered_to}
end

defmodule CommunityGarden do
  @spec start(%{plots: %{Plot.plot_id() => Plot.t()}, next_id: Plot.plot_id()}) :: {:ok, pid()}
  def start(opts \\ %{plots: %{}, next_id: 1}), do: Agent.start(fn -> opts end)

  @spec list_registrations(pid()) :: [Plot.t()]
  def list_registrations(pid), do: Agent.get(pid, &get_in(&1, [:plots, Access.values()]))

  @spec register(pid(), Plot.registered_to()) :: Plot.t()
  def register(pid, registered_to) do
    Agent.get_and_update(pid, fn %{next_id: next_id} = state ->
      new_plot = Plot.new(next_id, registered_to)
      new_state = state |> put_in([:plots, next_id], new_plot) |> update_in([:next_id], &(&1 + 1))
      {new_plot, new_state}
    end)
  end

  @spec release(pid(), Plot.plot_id()) :: :ok
  def release(pid, plot_id) do
    Agent.cast(pid, fn state -> update_in(state, [:plots], &Map.delete(&1, plot_id)) end)
  end

  @spec get_registration(pid(), Plot.plot_id()) :: Plot.t() | {:not_found, String.t()}
  def get_registration(pid, plot_id) do
    Agent.get(pid, &get_in(&1, [:plots, plot_id])) || {:not_found, "plot is unregistered"}
  end
end

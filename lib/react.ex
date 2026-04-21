defmodule React do
  use GenServer

  defmodule State do
    defstruct inputs: %{}, outputs: %{}, callbacks: %{}

    @type cell() :: {:input, String.t(), any} | {:output, String.t(), [String.t()], fun()}
    @type t :: %__MODULE__{
            inputs: %{String.t() => any()},
            outputs: %{String.t() => {[String.t()], fun()}},
            callbacks: %{String.t() => {String.t(), fun()}}
          }

    @spec new([cell()]) :: t()
    def new(cells), do: Enum.reduce(cells, %__MODULE__{}, &add_cell(&2, &1))

    @spec get_cell(t(), String.t()) :: any()
    def get_cell(%{inputs: inputs}, name) when is_map_key(inputs, name),
      do: Map.get(inputs, name)

    def get_cell(%{outputs: outputs} = state, name) when is_map_key(outputs, name) do
      {cells, fun} = Map.get(outputs, name)
      apply(fun, Enum.map(cells, &get_cell(state, &1)))
    end

    @spec add_cell(t(), cell()) :: t()
    def add_cell(%{outputs: outputs} = state, {:output, name, fun_args, fun}) do
      %{state | outputs: Map.put(outputs, name, {fun_args, fun})}
    end

    def add_cell(%{inputs: inputs, callbacks: callbacks} = state, {:input, name, value}) do
      new_state = %{state | inputs: Map.put(inputs, name, value)}

      for {cb_name, {cb_cell, cb_fun}} <- callbacks,
          new_value = get_cell(new_state, cb_cell),
          old_value = get_cell(state, cb_cell),
          old_value != new_value do
        cb_fun.(cb_name, new_value)
      end

      new_state
    end

    @spec add_callback(t(), String.t(), String.t(), fun()) :: t()
    def add_callback(%{callbacks: callbacks} = state, name, cell_name, fun) do
      %{state | callbacks: Map.put(callbacks, name, {cell_name, fun})}
    end

    @spec remove_callback(t(), String.t()) :: t()
    def remove_callback(%{callbacks: callbacks} = state, name) do
      %{state | callbacks: Map.delete(callbacks, name)}
    end
  end

  @type cell :: {:input, String.t(), any} | {:output, String.t(), [String.t()], fun()}

  ## API

  @doc """
  Start a reactive system
  """
  @spec new([cell()]) :: {:ok, pid}
  def new(cells), do: GenServer.start_link(__MODULE__, cells)

  @doc """
  Return the value of an input or output cell
  """
  @spec get_value(pid(), String.t()) :: any()
  def get_value(pid, cell_name), do: GenServer.call(pid, {:get_value, cell_name})

  @doc """
  Set the value of an input cell
  """
  @spec set_value(pid(), String.t(), any) :: :ok
  def set_value(pid, name, value), do: GenServer.cast(pid, {:set_value, name, value})

  @doc """
  Add a callback to an output cell
  """
  @spec add_callback(pid(), String.t(), String.t(), fun()) :: :ok
  def add_callback(pid, cell_name, callback_name, fun) do
    GenServer.cast(pid, {:add_callback, callback_name, cell_name, fun})
  end

  @doc """
  Remove a callback from an output cell
  """
  @spec remove_callback(pid(), String.t(), String.t()) :: :ok
  def remove_callback(pid, _cell_name, callback_name) do
    GenServer.cast(pid, {:remove_callback, callback_name})
  end

  ## Callbacks

  @impl true
  def init(cells), do: {:ok, State.new(cells)}

  @impl true
  def handle_call({:get_value, name}, _from, state) do
    {:reply, State.get_cell(state, name), state}
  end

  @impl true
  def handle_cast({:set_value, name, value}, state) do
    {:noreply, State.add_cell(state, {:input, name, value})}
  end

  def handle_cast({:add_callback, name, cell_name, callback_fun}, state) do
    {:noreply, State.add_callback(state, name, cell_name, callback_fun)}
  end

  def handle_cast({:remove_callback, name}, state) do
    {:noreply, State.remove_callback(state, name)}
  end
end

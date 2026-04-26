defmodule CircularBuffer do
  defmodule State do
    defstruct [:capacity, length: 0, queue: :queue.new()]

    @type t() :: %__MODULE__{
            capacity: non_neg_integer(),
            length: non_neg_integer(),
            queue: :queue.queue(any())
          }

    defguardp is_capacity(n) when is_integer(n) and n > 0

    @spec new(pos_integer()) :: {:ok, t()} | {:error, atom()}
    def new(capacity) when is_capacity(capacity), do: {:ok, %__MODULE__{capacity: capacity}}
    def new(_), do: {:error, :invalid_capacity}

    @spec read(t()) :: {:ok, {any(), t()}} | {:error, atom()}
    def read(%{length: 0}), do: {:error, :empty}

    def read(%{capacity: c, length: l, queue: q} = state) do
      {{:value, value}, new_queue} = :queue.out(q)
      new_state = %{state | capacity: c + 1, length: l - 1, queue: new_queue}
      {:ok, {value, new_state}}
    end

    @spec write(t(), any()) :: {:ok, t()} | {:error, atom()}
    def write(%{capacity: 0}, _), do: {:error, :full}

    def write(%{capacity: c, length: l, queue: q} = state, item) do
      {:ok, %{state | capacity: c - 1, length: l + 1, queue: :queue.in(item, q)}}
    end

    @spec overwrite(t(), any()) :: {:ok, t()}
    def overwrite(%{capacity: 0, length: l} = state, item) when l != 0 do
      {:ok, {_, new_state}} = read(state)
      write(new_state, item)
    end

    def overwrite(state, item), do: write(state, item)

    @spec clear(t()) :: {:ok, t()}
    def clear(%{capacity: c, length: l}), do: new(l + c)
  end

  use GenServer

  @moduledoc """
  An API to a stateful process that fills and empties a circular buffer
  """

  @doc """
  Create a new buffer of a given capacity
  """
  @spec new(pos_integer()) :: {:ok, pid()}
  def new(capacity), do: GenServer.start_link(__MODULE__, capacity)

  @doc """
  Read the oldest entry in the buffer, fail if it is empty
  """
  @spec read(pid()) :: {:ok, any()} | {:error, atom()}
  def read(buffer), do: GenServer.call(buffer, :read)

  @doc """
  Write a new item in the buffer, fail if is full
  """
  @spec write(pid(), any()) :: :ok | {:error, atom()}
  def write(buffer, item), do: GenServer.call(buffer, {:write, item})

  @doc """
  Write an item in the buffer, overwrite the oldest entry if it is full
  """
  @spec overwrite(pid(), any()) :: :ok
  def overwrite(buffer, item), do: GenServer.cast(buffer, {:overwrite, item})

  @doc """
  Clear the buffer
  """
  @spec clear(pid()) :: :ok
  def clear(buffer), do: GenServer.cast(buffer, :clear)

  @impl true
  def init(capacity) do
    case State.new(capacity) do
      {:ok, state} -> {:ok, state}
      {:error, error} -> {:stop, {:error, error}}
    end
  end

  @impl true
  def handle_call(:read, _from, state) do
    case State.read(state) do
      {:ok, {value, new_state}} -> {:reply, {:ok, value}, new_state}
      error -> {:reply, error, state}
    end
  end

  def handle_call({:write, item}, _from, state) do
    case State.write(state, item) do
      {:ok, new_state} -> {:reply, :ok, new_state}
      error -> {:reply, error, state}
    end
  end

  @impl true
  def handle_cast({:overwrite, item}, state) do
    {:ok, new_state} = State.overwrite(state, item)
    {:noreply, new_state}
  end

  @impl true
  def handle_cast(:clear, state) do
    {:ok, new_state} = State.clear(state)
    {:noreply, new_state}
  end
end

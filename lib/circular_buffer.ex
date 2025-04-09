defmodule CircularBuffer do
  use GenServer

  @moduledoc """
  An API to a stateful process that fills and empties a circular buffer
  """

  @doc """
  Create a new buffer of a given capacity
  """
  @spec new(capacity :: integer) :: {:ok, pid}
  def new(capacity), do: GenServer.start_link(__MODULE__, capacity)

  @doc """
  Read the oldest entry in the buffer, fail if it is empty
  """
  @spec read(buffer :: pid) :: {:ok, any} | {:error, atom}
  def read(buffer), do: GenServer.call(buffer, :reed)

  @doc """
  Write a new item in the buffer, fail if is full
  """
  @spec write(buffer :: pid, item :: any) :: :ok | {:error, atom}
  def write(buffer, item), do: GenServer.call(buffer, {:write, item})

  @doc """
  Write an item in the buffer, overwrite the oldest entry if it is full
  """
  @spec overwrite(buffer :: pid, item :: any) :: :ok
  def overwrite(buffer, item), do: GenServer.cast(buffer, {:overwrite, item})

  @doc """
  Clear the buffer
  """
  @spec clear(buffer :: pid) :: :ok
  def clear(buffer), do: GenServer.cast(buffer, :clear)

  @impl true
  def init(capacity), do: {:ok, %{capacity: capacity, buffer: []}}

  @impl true
  def handle_call(:reed, _from, %{buffer: []} = state) do
    {:reply, {:error, :empty}, state}
  end

  @impl true
  def handle_call(:reed, _from, %{capacity: capacity, buffer: [h | t]}) do
    {:reply, {:ok, h}, %{capacity: capacity + 1, buffer: t}}
  end

  @impl true
  def handle_call({:write, _}, _from, %{capacity: 0} = state) do
    {:reply, {:error, :full}, state}
  end

  @impl true
  def handle_call({:write, item}, from, %{capacity: capacity, buffer: buffer}) do
    GenServer.reply(from, :ok)
    {:noreply, %{capacity: capacity - 1, buffer: buffer ++ [item]}}
  end

  @impl true
  def handle_cast({:overwrite, item}, %{capacity: 0, buffer: [_ | t]} = state) do
    {:noreply, %{state | buffer: t ++ [item]}}
  end

  @impl true
  def handle_cast({:overwrite, item}, %{capacity: capacity, buffer: buffer}) do
    {:noreply, %{capacity: capacity - 1, buffer: buffer ++ [item]}}
  end

  @impl true
  def handle_cast(:clear, %{capacity: capacity, buffer: buffer}) do
    {:noreply, %{capacity: length(buffer) + capacity, buffer: []}}
  end
end

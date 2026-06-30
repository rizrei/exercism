# credo:disable-for-this-file

# defmodule TakeANumber do
#   def start, do: spawn(__MODULE__, :loop, [])

#   def loop(state \\ 0) do
#     receive do
#       {:report_state, sender_pid} ->
#         send(sender_pid, state)
#         loop(state)

#       {:take_a_number, sender_pid} ->
#         new_state = state + 1
#         send(sender_pid, new_state)
#         loop(new_state)

#       :stop ->
#         :stop

#       _ ->
#         loop(state)
#     end
#   end
# end

# credo:disable-for-this-file

defmodule TakeANumber do
  use GenServer

  require Logger

  ### Client API
  def start(number \\ 0), do: GenServer.start(__MODULE__, number)

  def report_state(pid), do: GenServer.call(pid, :report_state)

  def take_a_number(pid), do: GenServer.call(pid, :take_a_number)

  def stop(pid), do: GenServer.stop(pid)

  ### Callbacks
  @impl true
  def init(number), do: {:ok, number}

  @impl true
  def handle_call(:report_state, _from, state), do: {:reply, state, state}

  @impl true
  def handle_call(:take_a_number, _from, state) do
    new_state = state + 1
    {:reply, new_state, new_state}
  end

  @impl true
  def handle_info(msg, state) do
    Logger.warning("Received unexpected message: #{inspect(msg)}")
    {:noreply, state}
  end
end

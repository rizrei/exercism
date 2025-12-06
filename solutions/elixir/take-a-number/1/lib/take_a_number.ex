defmodule TakeANumber do
  def start do
    spawn(fn -> loop(0) end)
  end

  def loop(state) do
    receive do
      {:report_state, sender_pid} ->
        send(sender_pid, state)
        loop(state)
      {:take_a_number, sender_pid} ->
        new_state = state + 1
        send(sender_pid, new_state)
        loop(new_state)
      :stop -> :stop
      _ -> loop(state)
    end
  end
end
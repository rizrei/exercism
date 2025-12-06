# Use the Plot struct as it is provided
defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]
end

defmodule CommunityGarden do
  def start(opts \\ %{plots: %{}, next_id: 1}), do: Agent.start(fn -> opts end)

  def list_registrations(pid) do
    pid |> get_state() |> Map.get(:plots) |> Map.values()
  end

  def register(pid, register_to) do
    Agent.get_and_update(pid, fn %{next_id: next_id} = state ->
      new_plot = %Plot{plot_id: next_id, registered_to: register_to}
      new_state = state |> put_in([:plots, next_id], new_plot) |> Map.put(:next_id, next_id + 1)
      {new_plot, new_state}
    end)
  end

  def release(pid, plot_id) do
    Agent.cast(pid, fn %{plots: plots} = state ->
      %{state | plots: plots |> Map.delete(plot_id)}
    end)
  end

  def get_registration(pid, plot_id) do
    pid
    |> get_state()
    |> Map.get(:plots)
    |> Map.get(plot_id, {:not_found, "plot is unregistered"})
  end

  defp get_state(pid), do: Agent.get(pid, fn state -> state end)
end

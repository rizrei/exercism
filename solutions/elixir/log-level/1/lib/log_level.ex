defmodule LogLevel do
  @spec to_label(integer, boolean) :: :debug | :error | :fatal | :info | :trace | :unknown | :warning
  def to_label(level, legacy?) do
    cond do
      level == 0 && legacy? == false -> :trace
      level == 1 -> :debug
      level == 2 -> :info
      level == 3 -> :warning
      level == 4 -> :error
      level == 5 && legacy? == false -> :fatal
      true -> :unknown
    end
  end

  @spec alert_recipient(integer, boolean) :: :dev1 | false | :ops
  def alert_recipient(level, legacy?) do
    log = to_label(level, legacy?)

    cond do
      log == :error -> :ops
      log == :fatal -> :ops
      log == :unknown && legacy? == true -> :dev1
      log == :unknown -> :dev2
      true -> false
    end
  end
end

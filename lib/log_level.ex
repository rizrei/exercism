# credo:disable-for-this-file

defmodule LogLevel do
  @type level :: :debug | :error | :fatal | :info | :trace | :unknown | :warning
  @spec to_label(integer, boolean) :: level
  def to_label(0, false), do: :trace
  def to_label(1, _), do: :debug
  def to_label(2, _), do: :info
  def to_label(3, _), do: :warning
  def to_label(4, _), do: :error
  def to_label(5, false), do: :fatal
  def to_label(_, _), do: :unknown

  @spec alert_recipient(integer, boolean) :: :dev1 | false | :ops
  def alert_recipient(level, legacy?) do
    to_label(level, legacy?) |> do_alert_recipient(legacy?)
  end

  @spec do_alert_recipient(level, boolean) :: :dev1 | false | :ops
  defp do_alert_recipient(:unknown, true), do: :dev1
  defp do_alert_recipient(:error, _), do: :ops
  defp do_alert_recipient(:fatal, _), do: :ops
  defp do_alert_recipient(:unknown, _), do: :dev2
  defp do_alert_recipient(_, _), do: false
end

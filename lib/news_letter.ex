# credo:disable-for-this-file

defmodule Newsletter do
  def read_emails(path), do: path |> File.read!() |> String.split(~r/\s/, trim: true)

  def open_log(path), do: path |> File.open!([:write])

  def log_sent_email(pid, email), do: pid |> IO.puts(email)

  def close_log(pid), do: pid |> File.close()

  def send_newsletter(emails_path, log_path, send_fn) do
    log = open_log(log_path)

    emails_path
    |> read_emails()
    |> Enum.each(fn email ->
      case send_fn.(email) do
        :ok -> log_sent_email(log, email)
        :error -> nil
      end
    end)

    close_log(log)
  end
end

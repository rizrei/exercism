# credo:disable-for-this-file

defmodule RPG.CharacterSheet do
  @welcome_message "Welcome! Let's fill out your character sheet together."
  @ask_name_message "What is your character's name?\n"
  @ask_class_message "What is your character's class?\n"
  @ask_level_message "What is your character's level?\n"
  @run_message "Your character: "

  @spec welcome :: :ok
  def welcome, do: @welcome_message |> IO.puts()

  @spec ask_name :: binary
  def ask_name, do: @ask_name_message |> IO.gets() |> String.trim()

  @spec ask_class :: binary
  def ask_class, do: @ask_class_message |> IO.gets() |> String.trim()

  @spec ask_level :: integer
  def ask_level, do: @ask_level_message |> IO.gets() |> String.trim() |> String.to_integer()

  @spec run :: %{class: binary, level: integer, name: binary}
  def run() do
    welcome()
    name = ask_name()
    class = ask_class()
    level = ask_level()
    # credo:disable-for-next-line
    IO.inspect(%{class: class, level: level, name: name}, label: @run_message)
  end
end

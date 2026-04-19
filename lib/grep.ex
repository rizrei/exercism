defmodule Grep do
  defstruct [:flags, :files, :regex, :mapper, :filter, :evaluator]

  @type stream() :: {line :: String.t(), index :: integer(), name :: String.t()}
  @type t :: %__MODULE__{
          flags: MapSet.t(String.t()),
          files: [String.t()],
          regex: Regex.t(),
          mapper: (stream() -> String.t()),
          filter: (stream() -> boolean()),
          evaluator: (Stream.element() -> [String.t()])
        }

  @spec grep(String.t(), [String.t()], [String.t()]) :: String.t()
  def grep(pattern, flags, files) do
    state = new(pattern, flags, files)

    state.files
    |> Task.async_stream(&grep_file(&1, state))
    |> Enum.flat_map(fn {:ok, result} -> result end)
    |> Enum.join()
  end

  defp new(pattern, flags, files) do
    %__MODULE__{flags: MapSet.new(flags), files: files}
    |> build_regex(pattern)
    |> build_filter()
    |> build_mapper()
    |> build_evaluator()
  end

  defp grep_file(file, %{filter: filter, mapper: mapper, evaluator: evaluator}) do
    name = Path.basename(file)

    file
    |> File.stream!()
    |> Stream.with_index(1)
    |> Stream.map(fn {line, index} -> {line, index, name} end)
    |> Stream.filter(filter)
    |> Stream.map(mapper)
    |> evaluator.()
  end

  defp build_regex(%{flags: flags} = state, pattern) do
    {source, opts} =
      Enum.reduce(flags, {pattern, []}, fn
        "-i", {source, opts} -> {source, [:caseless | opts]}
        "-x", {source, opts} -> {"^#{source}$", opts}
        _, {source, opts} -> {source, opts}
      end)

    %{state | regex: Regex.compile!(source, opts)}
  end

  defp build_filter(%{regex: regex, flags: flags} = state) do
    filter =
      if MapSet.member?(flags, "-v") do
        fn {line, _idx, _name} -> not String.match?(line, regex) end
      else
        fn {line, _idx, _name} -> String.match?(line, regex) end
      end

    %{state | filter: filter}
  end

  defp build_mapper(%{flags: flags, files: files} = state) do
    mapper =
      cond do
        MapSet.member?(flags, "-l") ->
          fn {_line, _idx, name} -> "#{name}\n" end

        MapSet.member?(flags, "-n") and length(files) > 1 ->
          fn {line, idx, name} -> "#{name}:#{idx}:#{line}" end

        MapSet.member?(flags, "-n") ->
          fn {line, idx, _name} -> "#{idx}:#{line}" end

        length(files) > 1 ->
          fn {line, _idx, name} -> "#{name}:#{line}" end

        true ->
          fn {line, _idx, _name} -> "#{line}" end
      end

    %{state | mapper: mapper}
  end

  defp build_evaluator(%{flags: flags} = state) do
    evaluator = if MapSet.member?(flags, "-l"), do: &Enum.take(&1, 1), else: &Enum.to_list/1

    %{state | evaluator: evaluator}
  end
end

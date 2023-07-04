defmodule Tournament do
  defmodule ResultTable do
    defmodule Score do
      defstruct mp: 0, w: 0, d: 0, l: 0, p: 0
    end

    def new, do: %{}

    def add_result(table, t1, t2, "win") do
      table
      |> Map.update(t1, %Score{mp: 1, w: 1, p: 3}, &add_score(&1, :win))
      |> Map.update(t2, %Score{mp: 1, l: 1}, &add_score(&1, :loss))
    end

    def add_result(table, t1, t2, "loss"), do: add_result(table, t2, t1, "win")

    def add_result(table, t1, t2, "draw") do
      table
      |> Map.update(t1, %Score{mp: 1, d: 1, p: 1}, &add_score(&1, :draw))
      |> Map.update(t2, %Score{mp: 1, d: 1, p: 1}, &add_score(&1, :draw))
    end

    def add_result(table, _, _, _), do: table

    defp add_score(%Score{mp: mp, w: w, p: p} = score, :win) do
      %{score | mp: mp + 1, w: w + 1, p: p + 3}
    end

    defp add_score(%Score{mp: mp, l: l} = score, :loss) do
      %{score | mp: mp + 1, l: l + 1}
    end

    defp add_score(%Score{mp: mp, d: d, p: p} = score, :draw) do
      %{score | mp: mp + 1, d: d + 1, p: p + 1}
    end
  end

  defmodule Formatter do
    def to_list(table) do
      table
      |> Enum.to_list()
      # Сортировка по двум полям с определенным направлением(:desc, :asc) для каждого
      |> Enum.sort_by(fn {_team, %{p: p}} -> p end, &Kernel.>=/2)
    end

    def to_table(list) do
      list
      |> Enum.map(fn {team, points} -> table_line(team, points) end)
      |> Enum.join("\n")
      |> String.replace_prefix("", "#{header()}\n")
    end

    def header do
      """
      #{rpad("Team", 30)} | #{lpad("MP", 2)} | #{lpad("W", 2)} |\
       #{lpad("D", 2)} | #{lpad("L", 2)} | #{lpad("P", 2)}\
      """
    end

    defp table_line(team_title, %{mp: mp, w: w, d: d, l: l, p: p}) do
      """
      #{rpad(team_title, 30)} | #{lpad(to_string(mp), 2)}\
       | #{lpad(to_string(w), 2)} | #{lpad(to_string(d), 2)}\
       | #{lpad(to_string(l), 2)} | #{lpad(to_string(p), 2)}\
      """
    end

    defp rpad(str, count), do: String.pad_trailing(str, count)
    defp lpad(str, count), do: String.pad_leading(str, count)
  end

  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """
  @spec tally(input :: list(String.t())) :: String.t()
  def tally([]), do: Formatter.header()

  def tally(input) do
    input
    |> Enum.filter(&(&1 =~ ~r/^.+;.+;(win|loss|draw)$/))
    |> Enum.map(&String.split(&1, ";"))
    |> Enum.reduce(ResultTable.new(), fn [t1, t2, result], acc ->
      ResultTable.add_result(acc, t1, t2, result)
    end)
    |> Formatter.to_list()
    |> Formatter.to_table()
  end
end

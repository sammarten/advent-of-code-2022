defmodule RockPaperScissors do
  @draw 3
  @win 6

  def run(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(fn [a, _space, b] -> [to_val(a), to_val(b)] end)
    |> Enum.reduce(0, &play_round/2)
  end

  def to_val(char) when char in ["A", "X"], do: 1
  def to_val(char) when char in ["B", "Y"], do: 2
  def to_val(char) when char in ["C", "Z"], do: 3

  def play_round([a, a], acc), do: a + @draw + acc

  def play_round([a, b], acc) do
    if winning_play?(a, b) do
      b + @win + acc
    else
      b + acc
    end
  end

  def winning_play?(a, b) do
    rem(a, 3) + 1 == b
  end
end

IO.inspect(RockPaperScissors.run("input.txt"))

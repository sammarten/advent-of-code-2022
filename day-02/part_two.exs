defmodule RockPaperScissors do
  @draw 3
  @win 6

  def run(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(fn [a, _space, b] -> [to_val(a), to_result(b)] end)
    |> Enum.reduce(0, &play_round/2)
  end

  def to_val("A"), do: 1
  def to_val("B"), do: 2
  def to_val("C"), do: 3

  def to_result("X"), do: "LOSE"
  def to_result("Y"), do: "DRAW"
  def to_result("Z"), do: "WIN"

  def play_round([a, "DRAW"], acc), do: a + @draw + acc

  def play_round([a, "WIN"], acc) do
    winning_play(a) + @win + acc
  end

  def play_round([a, "LOSE"], acc) do
    losing_play(a) + acc
  end

  def winning_play(a) do
    rem(a, 3) + 1
  end

  def losing_play(a) do
    rem(a + 1, 3) + 1
  end
end

IO.inspect(RockPaperScissors.run("input.txt"))

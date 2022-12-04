defmodule CampCleanup do
  def run(filename \\ "input.txt") do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&parse_pairs/1)
    |> Enum.filter(&has_full_overlap?/1)
    |> Enum.count()
  end

  def parse_pairs(line) do
    line
    |> String.split(",")
    |> Enum.map(&String.split(&1, "-"))
    |> Enum.map(&to_integers/1)
  end

  def to_integers(strings) do
    Enum.map(strings, &String.to_integer/1)
  end

  def has_full_overlap?([[a, b], [c, d]]) when a <= c and b >= d, do: true
  def has_full_overlap?([[a, b], [c, d]]) when c <= a and d >= b, do: true
  def has_full_overlap?(_), do: false
end

IO.inspect(CampCleanup.run())

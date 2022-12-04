defmodule CampCleanup do
  def run(filename \\ "input.txt") do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&parse_pairs/1)
    |> Enum.filter(&has_overlap?/1)
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

  def has_overlap?([[a, b], [c, d]]) do
    MapSet.intersection(MapSet.new(a..b), MapSet.new(c..d)) 
    |> MapSet.size() 
    |> Kernel.>(0)
  end

  def has_full_overlap?(_), do: false
end

IO.inspect(CampCleanup.run())

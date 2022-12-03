defmodule RucksackReorganization do
  @items "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
  @item_priority_lookup @items |> String.graphemes() |> Enum.with_index(1) |> Enum.into(%{})

  def run(filename \\ "input.txt") do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.chunk_every(3, 3)
    |> Enum.map(&find_common_item/1)
    |> Enum.sum()
  end

  def find_common_item([items_1, items_2, items_3]) do
    [item] =
      MapSet.intersection(MapSet.new(items_1), MapSet.new(items_2))
      |> MapSet.intersection(MapSet.new(items_3))
      |> MapSet.to_list()

    @item_priority_lookup[item]
  end
end

IO.inspect(RucksackReorganization.run())

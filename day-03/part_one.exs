defmodule RucksackReorganization do
  @items "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
  @item_priority_lookup @items |> String.graphemes() |> Enum.with_index(1) |> Enum.into(%{})

  def run(filename \\ "input.txt") do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&find_common_item/1)
    |> Enum.sum()
  end

  def find_common_item(items) do
    {compartment_1, compartment_2} = Enum.split(items, round(length(items) / 2))

    [item] = 
      MapSet.intersection(MapSet.new(compartment_1), MapSet.new(compartment_2)) 
      |> MapSet.to_list()

    @item_priority_lookup[item]
  end
end

IO.inspect(RucksackReorganization.run())

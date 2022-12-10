defmodule TreetopTreeHouse do
  def run(filename \\ "input.txt") do
    filename
    |> read_file()
    |> find_visible_trees()
  end

  def read_file(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
    |> Enum.reduce(%{row: 1, tree_map: %{}}, &reduce_line/2)
    |> Map.get(:tree_map)
  end

  def parse_line(line) do
    line 
    |> String.graphemes() 
    |> Enum.map(&String.to_integer/1)
  end

  def reduce_line(line, context) do
    updated_tree_map =
      line
      |> Enum.with_index(1)
      |> Enum.reduce(context.tree_map, fn {tree, col}, acc ->
        Map.put(acc, {context.row, col}, tree)
      end)

    %{row: context.row + 1, tree_map: updated_tree_map}
  end

  def find_visible_trees(trees) do
    num_rows =
      trees
      |> Map.keys()
      |> Enum.map(fn {row, _} -> row end)
      |> Enum.max()

    num_cols =
      trees
      |> Map.keys()
      |> Enum.map(fn {_, col} -> col end)
      |> Enum.max()

    trees
    |> Enum.reduce([], &filter_visibility(&1, &2, num_rows, num_cols, trees))
    |> Enum.count()
  end

  def filter_visibility({{1, _col} = tree, _height}, visible_trees, _num_rows, _num_cols, _trees), do: [tree | visible_trees]
  def filter_visibility({{_row, 1} = tree, _height}, visible_trees, _num_rows, _num_cols, _trees), do: [tree | visible_trees]
  def filter_visibility({{bottom_row, _col} = tree, _height}, visible_trees, bottom_row, _num_cols, _trees), do: [tree | visible_trees]
  def filter_visibility({{_row, right_col} = tree, _height}, visible_trees, _num_rows, right_col, _trees), do: [tree | visible_trees]

  def filter_visibility({{row, col}, height} = tree, visible_trees, num_rows, num_cols, trees) do
    if visible?(row, col, height, num_rows, num_cols, trees), do: [tree | visible_trees], else: visible_trees
  end

  def visible?(row, col, height, num_rows, num_cols, trees) do
    visible_in_row?(height, row, 1..(col-1), trees) ||
    visible_in_row?(height, row, (col+1)..num_cols, trees) ||
    visible_in_col?(height, col, 1..(row-1), trees) ||
    visible_in_col?(height, col, (row+1)..num_rows, trees)
  end

  def visible_in_row?(height, row, col_range, trees) do
    col_range
    |> Stream.map(&{row, &1})
    |> Enum.map(&Map.get(trees, &1))
    |> Enum.max()
    |> Kernel.<(height)
  end

  def visible_in_col?(height, col, row_range, trees) do
    row_range
    |> Stream.map(&{&1, col})
    |> Enum.map(&Map.get(trees, &1))
    |> Enum.max()
    |> Kernel.<(height)
  end
end

IO.inspect(TreetopTreeHouse.run())

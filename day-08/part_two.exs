defmodule TreetopTreeHouse do
  def run(filename \\ "input.txt") do
    filename
    |> read_file()
    |> find_max_scenic_score()
  end

  def read_file(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Stream.map(&parse_line/1)
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
      |> Stream.with_index(1)
      |> Enum.reduce(context.tree_map, fn {tree, col}, acc ->
        Map.put(acc, {context.row, col}, tree)
      end)

    %{row: context.row + 1, tree_map: updated_tree_map}
  end

  def find_max_scenic_score(trees) do
    num_rows =
      trees
      |> Map.keys()
      |> Stream.map(fn {row, _} -> row end)
      |> Enum.max()

    num_cols =
      trees
      |> Map.keys()
      |> Enum.map(fn {_, col} -> col end)
      |> Enum.max()

    trees
    |> Stream.map(&calc_scenic_score(&1, num_rows, num_cols, trees))
    |> Enum.max()
  end

  def calc_scenic_score({{row, col}, height}, num_rows, num_cols, trees) do
    left_count(row, col, height, trees) *
    right_count(row, col, height, num_cols, trees) *
    up_count(row, col, height, trees) *
    bottom_count(row, col, height, num_rows, trees)
  end

  def left_count(_row, 1, _height, _trees), do: 0
  def left_count(row, col, height, trees) do
    Enum.reduce_while((col-1)..1, 0, fn compare_col, count ->
      if height > Map.get(trees, {row, compare_col}) do
        {:cont, count + 1}
      else
        {:halt, count + 1}
      end
    end)
  end

  def right_count(_row, num_cols, _height, num_cols, _trees), do: 0
  def right_count(row, col, height, num_cols, trees) do
    Enum.reduce_while((col+1)..num_cols, 0, fn compare_col, count ->
      if height > Map.get(trees, {row, compare_col}) do
        {:cont, count + 1}
      else
        {:halt, count + 1}
      end
    end)
  end

  def up_count(1, _col, _height, _trees), do: 0
  def up_count(row, col, height, trees) do
    Enum.reduce_while((row-1)..1, 0, fn compare_row, count ->
      if height > Map.get(trees, {compare_row, col}) do
        {:cont, count + 1}
      else
        {:halt, count + 1}
      end
    end)
  end

  def bottom_count(num_rows, _col, _height, num_rows, _trees), do: 0
  def bottom_count(row, col, height, num_rows, trees) do
    Enum.reduce_while((row+1)..num_rows, 0, fn compare_row, count ->
      if height > Map.get(trees, {compare_row, col}) do
        {:cont, count + 1}
      else
        {:halt, count + 1}
      end
    end)
  end
end

IO.inspect(TreetopTreeHouse.run())

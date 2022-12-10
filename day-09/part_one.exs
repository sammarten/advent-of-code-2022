defmodule RopeBridge do
  def run(filename \\ "input.txt") do
    filename
    |> parse_commands()
    |> run_commands()
  end

  def parse_commands(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Stream.map(&String.split(&1, " "))
    |> Enum.map(fn [direction, steps] -> [direction, String.to_integer(steps)] end)
  end

  def run_commands(commands) do
    context = %{h: {0, 0}, t: {0, 0}, visited: MapSet.new([{0, 0}])}

    commands
    |> Enum.reduce(context, &run_command/2)
    |> Map.get(:visited)
    |> MapSet.size()
  end

  def run_command(["R", steps], context) do
    Enum.reduce(1..steps, context, fn _step, acc -> take_step(:right, acc) end)
  end

  def run_command(["L", steps], context) do
    Enum.reduce(1..steps, context, fn _step, acc -> take_step(:left, acc) end)
  end

  def run_command(["U", steps], context) do
    Enum.reduce(1..steps, context, fn _step, acc -> take_step(:up, acc) end)
  end
  
  def run_command(["D", steps], context) do
    Enum.reduce(1..steps, context, fn _step, acc -> take_step(:down, acc) end)
  end

  def take_step(direction, context) do    
    %{h: h, t: t, visited: visited} = context

    updated_h = update_h(direction, h)
    updated_t = update_t(updated_h, t)
    updated_visited = update_visited(visited, updated_t)

    %{
      h: updated_h,
      t: updated_t,
      visited: updated_visited
    }
  end

  def update_h(:right, {x, y}), do: {x + 1, y}
  def update_h(:left, {x, y}), do: {x - 1, y}
  def update_h(:up, {x, y}), do: {x, y + 1}
  def update_h(:down, {x, y}), do: {x, y - 1}

  def update_t(h, t) do
    cond do
      touching?(h, t) -> t
      vertical?(h, t) -> adjust_tail_vertically(h, t)
      horizontal?(h, t) -> adjust_tail_horizontally(h, t)
      true -> adjust_tail_diagonally(h, t)
    end
  end

  def touching?({h_x, h_y}, {t_x, t_y}) do
    abs(h_x - t_x) <= 1 && abs(h_y - t_y) <= 1
  end

  def vertical?({x, _}, {x, _}), do: true
  def vertical?(_, _), do: false

  def adjust_tail_vertically({x, h_y}, {x, t_y}) do
    if h_y > t_y, do: {x, t_y + 1}, else: {x, t_y - 1}
  end

  def horizontal?({_, y}, {_, y}), do: true
  def horizontal?(_, _), do: false

  def adjust_tail_horizontally({h_x, y}, {t_x, y}) do
    if h_x > t_x, do: {t_x + 1, y}, else: {t_x - 1, y}
  end

  def adjust_tail_diagonally({h_x, h_y}, {t_x, t_y}) do
    adjust_x =
      if h_x > t_x, do: 1, else: -1

    adjust_y =
      if h_y > t_y, do: 1, else: -1

    {t_x + adjust_x, t_y + adjust_y}
  end

  def update_visited(visited, t) do
    MapSet.union(visited, MapSet.new([t]))
  end
end

IO.inspect(RopeBridge.run())

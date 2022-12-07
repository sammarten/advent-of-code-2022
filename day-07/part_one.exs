defmodule NoSpaceOnDevice do
  @max_total_size 100_000

  def run(filename \\ "input.txt") do
    filename
    |> read_file()
    |> process_commands()
    |> filter_dirs()
  end

  def read_file(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
  end

  def process_commands(commands) do
    Enum.reduce(commands, %{path: [], current_dir: nil, dirs: %{}}, &process_command/2)
  end

  def process_command(["$", "cd", ".."], acc) do
    updated_path = Enum.drop(acc.path, -1)
    updated_current_dir = Enum.join(updated_path, "/")

    acc
    |> Map.put(:path, updated_path)
    |> Map.put(:current_dir, updated_current_dir)
  end

  def process_command(["$", "cd", dir], acc) do
    updated_path = acc.path ++ [dir]
    updated_current_dir = Enum.join(updated_path, "/")

    acc
    |> Map.put(:path, updated_path)
    |> Map.put(:current_dir, updated_current_dir)
    |> Map.put(:dirs, Map.put(acc.dirs, updated_current_dir, %{size: 0, dirs: []}))
  end

  def process_command(["$", "ls"], acc), do: acc

  def process_command(["dir", dir], acc) do
    update_in(acc, [:dirs, acc.current_dir, :dirs], &(&1 ++ [acc.current_dir <> "/" <> dir]))
  end

  def process_command([size, _file], acc) do
    update_in(acc, [:dirs, acc.current_dir, :size], &(&1 + String.to_integer(size)))
  end

  def filter_dirs(%{dirs: dirs}) do
    dirs
    |> Map.values()
    |> Enum.map(&calc_dir_size(&1, dirs))
    |> Enum.filter(&(&1 <= @max_total_size))
    |> Enum.sum()
  end

  def calc_dir_size(%{size: size, dirs: dirs}, dir_context) do
    sub_dir_size = 
      dirs
      |> Enum.map(&calc_dir_size(Map.get(dir_context, &1), dir_context))
      |> Enum.sum()

    size + sub_dir_size
  end
end

IO.inspect(NoSpaceOnDevice.run())

defmodule SupplyStacks do
  def run(filename \\ "input.txt") do
    filename
    |> read_file()
    |> execute_moves()
    |> list_top_crates()
  end

  def read_file(filename) do
    [stacks, moves] =
      filename
      |> File.read!()
      |> String.split("\n\n")

    %{stacks: init_stacks(stacks), moves: init_moves(moves)}
  end

  def init_stacks(stacks) do
    stacks
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.reverse()
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.reject(&(hd(&1) == " "))
    |> Enum.reduce(%{}, &init_stack/2)
  end

  def init_stack([stack_num | stack], acc) do
    cleaned_stack =
      stack
      |> Enum.reject(&(&1 == " "))
      |> Enum.reverse()

    Map.put(acc, stack_num, cleaned_stack)
  end

  def init_moves(moves) do
    moves
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
    |> Enum.reduce([], &init_move/2)
  end

  def init_move(["move", amount, "from", from_stack_id, "to", to_stack_id], acc) do
    acc ++ [%{amount: String.to_integer(amount), from_stack_id: from_stack_id, to_stack_id: to_stack_id}]
  end

  def execute_moves(%{moves: moves, stacks: stacks}) do
    Enum.reduce(moves, stacks, &execute_move/2)
  end

  def execute_move(%{amount: amount, from_stack_id: from_stack_id, to_stack_id: to_stack_id}, stacks) do
    {to_move, updated_from_stack} =
      stacks
      |> Map.get(from_stack_id)
      |> Enum.split(amount)

    to_stack = Map.get(stacks, to_stack_id)

    updated_to_stack =
      to_move
      |> Enum.reverse()
      |> Kernel.++(to_stack)

    stacks
    |> Map.put(from_stack_id, updated_from_stack)
    |> Map.put(to_stack_id, updated_to_stack)
  end

  def list_top_crates(stacks) do
    stacks
    |> Map.values()
    |> Enum.map(&List.first/1)
    |> Enum.join()
  end
end

IO.inspect(SupplyStacks.run("input.txt"))

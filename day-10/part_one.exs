defmodule CathodeRayTube do
  @signal_strengths [20, 60, 100, 140, 180, 220]

  def run(filename \\ "input.txt") do
    filename
    |> read_instructions()
    |> execute_instructions()
    |> calc_register_score()
  end

  def read_instructions(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&parse_instruction/1)
  end

  def parse_instruction(instruction) do
    case String.split(instruction, " ") do
      ["noop"] -> "noop"
      ["addx", amount] -> ["addx", String.to_integer(amount)]
    end
  end

  def execute_instructions(instructions) do
    instructions
    |> Enum.reduce([1, 1], &execute_instruction/2)
    |> Enum.reverse()
  end

  def execute_instruction("noop", [value | _] = values), do: [value | values]
  def execute_instruction(["addx", amount], [value | _] = values), do: [value + amount, value] ++ values

  def calc_register_score(register_values) do
    Enum.reduce(@signal_strengths, 0, fn cycle, acc -> (cycle * Enum.at(register_values, cycle)) + acc end)
  end
end

IO.inspect(CathodeRayTube.run())

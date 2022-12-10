defmodule CathodeRayTube do
  @screen_width 40

  def run(filename \\ "input.txt") do
    filename
    |> read_instructions()
    |> execute_instructions()
    |> render_screen()
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

  def render_screen([_ | register_values]) do
    register_values
    |> Enum.chunk_every(40, 40, :discard)
    |> Enum.map(&scan_line/1)
  end

  def scan_line(register_values) do
    Enum.reduce(0..@screen_width-1, "", fn drawing_position, acc ->
      if abs(drawing_position - Enum.at(register_values, drawing_position)) <= 1, do: acc <> "#", else: acc <> " "
    end)
  end
end

IO.inspect(CathodeRayTube.run() |> Enum.each(&IO.puts/1))

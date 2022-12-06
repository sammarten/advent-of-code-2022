defmodule TuningTrouble do
  @message_marker_size 14

  def run(filename \\ "input.txt") do
    filename
    |> File.read!()
    |> String.graphemes()
    |> Enum.chunk_every(@message_marker_size, 1)
    |> Enum.reduce_while(@message_marker_size, fn chunk, steps ->
      if unique?(chunk), do: {:halt, steps}, else: {:cont, steps + 1}
    end)
  end

  def unique?(chunk) do
    chunk
    |> Enum.uniq()
    |> Enum.count()
    |> Kernel.==(@message_marker_size)
  end
end

IO.inspect(TuningTrouble.run())

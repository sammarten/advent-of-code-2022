defmodule CalorieCounting do
  def run(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.chunk_by(&(&1 == ""))
    |> Enum.reject(&(&1 == [""]))
    |> Enum.map(&to_integers/1)
    |> Enum.map(&Enum.sum/1)
    |> Enum.sort(:desc)
    |> List.first()
  end

  defp to_integers(list) do
    Enum.map(list, &String.to_integer/1)
  end
end

IO.inspect(CalorieCounting.run("input.txt"))

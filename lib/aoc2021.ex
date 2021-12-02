defmodule Aoc2021 do
  def read_lines!(filename) do
    filename
    |> File.stream!()
    |> Enum.map(&String.trim/1)
  end

  def input_lines(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
  end
end

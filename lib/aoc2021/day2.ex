defmodule Aoc2021.Day2 do
  @input Aoc2021.read_lines!("input/day2.txt")

  def run do
    commands =
      @input
      |> Enum.map(&String.split/1)
      |> Enum.map(fn [dir, num] -> {dir, String.to_integer(num)} end)

    part1 =
      commands
      |> Enum.reduce({0, 0}, fn command, {horizontal, depth} ->
        case command do
          {"up", x} -> {horizontal, depth - x}
          {"down", x} -> {horizontal, depth + x}
          {"forward", x} -> {horizontal + x, depth}
        end
      end)
      |> Tuple.product()

    part2 =
      commands
      |> Enum.reduce({0, 0, 0}, fn command, {horizontal, depth, aim} ->
        case command do
          {"up", x} -> {horizontal, depth, aim - x}
          {"down", x} -> {horizontal, depth, aim + x}
          {"forward", x} -> {horizontal + x, depth + aim * x, aim}
        end
      end)
      |> Tuple.delete_at(2)
      |> Tuple.product()

    {:ok, part1, part2}
  end
end

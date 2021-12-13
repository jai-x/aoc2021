defmodule Aoc2021.Cli do
  @moduledoc "Usage: ./aoc2021 --day <num>"

  def main(argv) do
    argv
    |> parse_day
    |> run_day
    |> print_result
  end

  defp parse_day(argv) do
    options = [strict: [day: :integer], aliases: [d: :day]]
    {opts, _} = OptionParser.parse!(argv, options)
    opts[:day]
  end

  defp print_result(result) do
    case result do
      {:ok, part1, part2} ->
        IO.puts("Part 1: #{part1}, Part 2: #{part2}")

      {:error, message} ->
        IO.puts(message)
    end
  end

  defp run_day(1), do: Aoc2021.Day1.run()
  defp run_day(2), do: Aoc2021.Day2.run()
  defp run_day(3), do: Aoc2021.Day3.run()
  defp run_day(4), do: Aoc2021.Day4.run()
  defp run_day(5), do: Aoc2021.Day5.run()
  defp run_day(6), do: Aoc2021.Day6.run()
  defp run_day(7), do: Aoc2021.Day7.run()
  defp run_day(8), do: Aoc2021.Day8.run()
  defp run_day(9), do: Aoc2021.Day9.run()
  defp run_day(10), do: Aoc2021.Day10.run()
  defp run_day(11), do: Aoc2021.Day11.run()
  defp run_day(nil), do: {:error, @moduledoc}
  defp run_day(day), do: {:error, "Day #{day} not implemented!"}
end

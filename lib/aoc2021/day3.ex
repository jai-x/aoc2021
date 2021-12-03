defmodule Aoc2021.Day3 do
  @input Aoc2021.read_lines!("input/day3.txt")

  def run do
    gamma =
      @input
      |> bit_count()
      |> mc_bits()
      |> String.to_integer(2)

    epsilon =
      @input
      |> bit_count()
      |> lc_bits()
      |> String.to_integer(2)

    part1 = epsilon * gamma

    oxygen =
      @input
      |> bit_filter(&mc_bits/1, 0)
      |> String.to_integer(2)

    co2 =
      @input
      |> bit_filter(&lc_bits/1, 0)
      |> String.to_integer(2)

    part2 = oxygen * co2

    {:ok, part1, part2}
  end

  defp bit_filter([last], _, _), do: last

  defp bit_filter(list, bit_func, position) do
    bit =
      list
      |> bit_count()
      |> bit_func.()
      |> String.at(position)

    list
    |> Enum.filter(fn str -> String.at(str, position) == bit end)
    |> bit_filter(bit_func, position + 1)
  end

  defp mc_bits(counts) do
    Enum.reduce(counts, "", fn count, bitstring ->
      cond do
        count[0] <= count[1] -> bitstring <> "1"
        count[0] > count[1] -> bitstring <> "0"
      end
    end)
  end

  defp lc_bits(counts) do
    Enum.reduce(counts, "", fn count, bitstring ->
      cond do
        count[0] <= count[1] -> bitstring <> "0"
        count[0] > count[1] -> bitstring <> "1"
      end
    end)
  end

  defp bit_count(readings), do: Enum.reduce(readings, [], &bit_count/2)

  defp bit_count(reading, []) do
    reading
    |> String.graphemes()
    |> Enum.map(fn x ->
      case x do
        "0" -> %{0 => 1, 1 => 0}
        "1" -> %{0 => 0, 1 => 1}
      end
    end)
  end

  defp bit_count(reading, counts) do
    reading
    |> String.graphemes()
    |> Enum.zip(counts)
    |> Enum.map(fn {b, c} ->
      case b do
        "0" -> %{c | 0 => c[0] + 1}
        "1" -> %{c | 1 => c[1] + 1}
      end
    end)
  end
end

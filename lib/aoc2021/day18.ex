defmodule Aoc2021.Day18 do
  @input Aoc2021.read_lines!("input/day18.txt")

  def run do
    numbers = Enum.map(@input, &parse/1)

    part1 =
      numbers
      |> Enum.reduce([], fn num, list -> list |> add(num) |> reduce() end)
      |> magnitude()

    part2 =
      cart(numbers, numbers)
      |> Enum.map(fn {x, y} -> add(x, y) end)
      |> Enum.map(&reduce/1)
      |> Enum.map(&magnitude/1)
      |> Enum.max()

    {:ok, part1, part2}
  end

  defp cart(l1, l2) do
    for i <- l1, j <- l2, do: {i, j}
  end

  defp parse(line) do
    line
    |> String.replace(",", "")
    |> String.graphemes()
    |> Enum.map(fn
      "[" -> :open
      "]" -> :close
      x -> String.to_integer(x)
    end)
  end

  defp magnitude(num) do
    num
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn
      [:open, :open] -> "(3 * "
      [:close, :close] -> "* 2)"
      [:close, :open] -> " + "
      [:open, x] -> "(3 * #{x} "
      [x, :close] -> "#{x} * 2)"
      [_, _] -> " + "
    end)
    |> Enum.join()
    |> Code.eval_string()
    |> elem(0)
  end

  def add([], a), do: a
  def add(l, r), do: [:open] ++ l ++ r ++ [:close]

  defp reduce(num) do
    case explode(num) do
      {:ok, expl_num} ->
        reduce(expl_num)

      {:noop, _} ->
        case split(num) do
          {:ok, spl_num} -> reduce(spl_num)
          {:noop, _} -> num
        end
    end
  end

  defp split(num) do
    case split_idx(num) do
      nil -> {:noop, num}
      idx -> {:ok, do_split(num, idx)}
    end
  end

  defp do_split(num, idx) do
    {subl, rest} = Enum.split(num, idx)
    {[mid], subr} = Enum.split(rest, 1)
    {l, r} = {floor(mid / 2), ceil(mid / 2)}

    subl ++ [:open, l, r, :close] ++ subr
  end

  defp split_idx(num), do: split_idx(num, 0)
  defp split_idx([:open | rest], i), do: split_idx(rest, i + 1)
  defp split_idx([:close | rest], i), do: split_idx(rest, i + 1)
  defp split_idx([x | _], i) when x > 9, do: i
  defp split_idx([_ | rest], i), do: split_idx(rest, i + 1)
  defp split_idx([], _), do: nil

  defp explode(num) do
    case explode_idx(num) do
      nil -> {:noop, num}
      idx -> {:ok, do_explode(num, idx)}
    end
  end

  def do_explode(num, idx) do
    {subl, rest} = Enum.split(num, idx)
    {[_, l, r, _], subr} = Enum.split(rest, 4)

    lidx = explode_idx_l(subl)
    ridx = explode_idx_r(subr)

    case {lidx, ridx} do
      {nil, _} -> subl ++ [0] ++ add_at(subr, ridx, r)
      {_, nil} -> add_at(subl, lidx, l) ++ [0] ++ subr
      {_, _} -> add_at(subl, lidx, l) ++ [0] ++ add_at(subr, ridx, r)
    end
  end

  defp add_at(list, idx, val) do
    sum = Enum.at(list, idx) + val
    List.replace_at(list, idx, sum)
  end

  defp explode_idx_l(list) do
    list
    |> Enum.with_index()
    |> Enum.reverse()
    |> Enum.reduce_while(nil, fn {elem, idx}, _ ->
      case elem do
        :open -> {:cont, nil}
        :close -> {:cont, nil}
        _ -> {:halt, idx}
      end
    end)
  end

  defp explode_idx_r(list) do
    Enum.find_index(list, fn x -> x != :open && x != :close end)
  end

  defp explode_idx(num), do: explode_idx(num, 0, 0)
  defp explode_idx([:open | rest], d, i), do: explode_idx(rest, d + 1, i + 1)
  defp explode_idx([:close | rest], d, i), do: explode_idx(rest, d - 1, i + 1)

  defp explode_idx([_ | rest], d, i) when d > 4 do
    [next | _] = rest

    cond do
      next == :open || next == :close -> explode_idx(rest, d + 1, i + 1)
      true -> i - 1
    end
  end

  defp explode_idx([_ | rest], d, i), do: explode_idx(rest, d, i + 1)
  defp explode_idx([], _, _), do: nil
end

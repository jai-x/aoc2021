defmodule Aoc2021.Day4 do
  @input Aoc2021.read_lines!("input/day4.txt")

  def run do
    draws = parse_draws(@input)
    boards = parse_boards(@input)

    {draw, winner} = find_winner(draws, boards)
    part1 = sum_unmarked(winner) * draw

    {last_draw, last_winner} = find_last_winner(draws, boards)
    part2 = sum_unmarked(last_winner) * last_draw

    {:ok, part1, part2}
  end

  defp sum_unmarked(%{w: _, h: _, board: board}) do
    Enum.reduce(board, 0, fn {x, marked}, acc ->
      if !marked, do: acc + x, else: acc
    end)
  end

  defp find_last_winner(draws, boards) do
    Enum.reduce_while(draws, boards, fn draw, boards ->
      {winners, losers} =
        boards
        |> apply_draw(draw)
        |> winners_and_losers()

      if length(losers) == 0 do
        {:halt, {draw, List.first(winners)}}
      else
        {:cont, losers}
      end
    end)
  end

  defp find_winner(draws, boards) do
    Enum.reduce_while(draws, boards, fn draw, boards ->
      {winners, losers} =
        boards
        |> apply_draw(draw)
        |> winners_and_losers()

      if length(winners) > 0 do
        {:halt, {draw, List.first(winners)}}
      else
        {:cont, losers}
      end
    end)
  end

  defp winners_and_losers(boards) do
    Enum.reduce(boards, {[], []}, fn board, {winners, losers} ->
      if is_winner(board) do
        {winners ++ [board], losers}
      else
        {winners, losers ++ [board]}
      end
    end)
  end

  defp is_winner(%{w: w, h: h, board: board}) do
    rows = board |> Enum.chunk_every(w)

    columns =
      Enum.reduce(0..(h - 1), [], fn hx, cols ->
        cols ++
          [
            Enum.reduce(0..(w - 1), [], fn wx, col ->
              col ++ [Enum.at(board, hx + wx * w)]
            end)
          ]
      end)

    (rows ++ columns)
    |> Enum.map(fn rc -> Enum.all?(rc, fn {_, marked} -> marked end) end)
    |> Enum.any?()
  end

  defp apply_draw(boards, draw) do
    Enum.map(boards, fn %{w: w, h: h, board: board} ->
      new_board =
        Enum.map(board, fn {x, state} ->
          if x == draw, do: {x, true}, else: {x, state}
        end)

      %{w: w, h: h, board: new_board}
    end)
  end

  defp parse_draws(input) do
    input
    |> List.first()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  defp parse_boards(input) do
    input
    |> Enum.drop(2)
    |> Enum.reduce([[]], fn line, list ->
      case line do
        "" ->
          list ++ [[]]

        other ->
          nums =
            other
            |> String.split()
            |> Enum.map(&String.to_integer/1)

          list
          |> List.pop_at(-1)
          |> then(fn {last, rem} -> rem ++ [last ++ [nums]] end)
      end
    end)
    |> Enum.reduce([], fn lines, list ->
      h = lines |> length()
      w = lines |> List.first() |> length()
      board = lines |> List.flatten() |> Enum.map(fn x -> {x, false} end)
      list ++ [%{w: w, h: h, board: board}]
    end)
  end
end

input =
  File.read!("input.txt")
  |> String.trim()
  |> String.trim("\n")
  |> String.split("\n")

draws = Enum.at(input,0)
|> String.split(",")
|> Enum.map(fn item ->
  {x, _} = Integer.parse(item)
   x
  end)

board_sheet_indexed =
  input
    |> Enum.take(2 -length(input))
    |> Enum.filter(fn item -> item != "" end)
    |> Enum.chunk_every(5)

board_sheet = board_sheet_indexed
    |> Enum.map(fn box ->
           Enum.with_index(box)
           |> Enum.map(fn {boxstr, _} ->
                Enum.filter(String.split(boxstr," "), fn itemstr ->
                  itemstr != ""
                end)
                |> Enum.map(fn item ->
                  {num, _ } = Integer.parse(item)
                  {num, "O"}
                end)
           end)
    end)


defmodule Bingo do
  def stamp_number(board, number) do
    Enum.map(board, fn row ->
      # IO.inspect(row)
      Enum.map(row, fn item ->
        # IO.inspect(item)
        {k, v} = item
        case k==number do
          true -> {k, "X"}
          false -> {k,v}
        end
      end)
    end)
  end

  def has_x(item) do
    {_, v} = item
    v == "X"
  end
  def item_at(board, row, column) do
    Enum.at(Enum.at(board,row),column)
  end

  def count_x_in_row(board, row) do
    indexes = for n <- 0..4, do: n
    tot_x = List.foldl(indexes,0, fn column,acc ->
      item = item_at(board,row,column)
      case has_x(item) do
        true -> acc + 1
        _ -> acc
      end
    end)
    tot_x
  end

  def count_x_in_column(board, column) do
    indexes = for n <- 0..4, do: n
    tot_x = List.foldl(indexes, 0, fn row, acc ->
      item = item_at(board,row,column)
      case has_x(item) do
        true -> acc + 1
        _ -> acc
      end
    end)
    tot_x
  end

  def completed_rows(board) do
    rows = for n <- 0..4, do: n
    Enum.map(rows, fn row ->
      tot_x = count_x_in_row(board,row)
      case tot_x do
        5 -> 1
        _ -> 0
      end
    end)
    |> Enum.sum()
  end

  def completed_columns(board) do
    columns = for n <- 0..4, do: n
    Enum.map(columns, fn col ->
      tot_x = count_x_in_column(board,col)
      case tot_x do
        5 -> 1
        _ -> 0
      end
    end)
    |> Enum.sum()
  end

  def is_board_completed(board) do
    # check if there is a row.
    tot_x = completed_rows(board)
    case tot_x > 0 do
      true -> 1
      _ -> case completed_columns(board) > 0 do
        true -> 1
        _ -> 0
      end
    end
  end

  def draw_until_winner(boards, [number|rest_draws]) do
    updated_boards = Enum.map(boards, fn board ->
      stamp_number(board, number)
    end)

    winner_boards = Enum.map(updated_boards, fn board ->
      is_board_completed(board)
    end)
    case Enum.sum(winner_boards) > 0 do
      # we have a winner board
      true -> {updated_boards,winner_boards, number}
      _ -> draw_until_winner(updated_boards, rest_draws)
    end
  end

  def draw_until_winner(boards, []) do
    {boards, [], -1}
  end
  def winner_board_at(boards, index) do
    Enum.at(boards,index)
  end
  def first_winner_board(boards, winner_boards) do
    Enum.with_index(winner_boards, fn win_val, index ->
      case win_val == 0 do
        true -> []
        _ -> Enum.at(boards,index)
      end
    end)
    |> Enum.filter(fn item ->
      length(item) > 0
    end)
  end

  def sum_unmarked(board) do
    Enum.reduce(board,0, fn rows, acc ->
      Enum.reduce(rows,acc, fn row,acc ->
        Enum.reduce(row,acc, fn item,acc ->
          {k, v} = item
          case v == "O" do
            true -> acc + k
            _ -> acc
          end
        end)
      end)
    end)
  end

  def remove_winner_boards(boards, winner_boards) do
    Enum.with_index(winner_boards, fn win_val, index ->
      case win_val == 1 do
        true -> []
        _ -> Enum.at(boards,index)
      end
    end)
    |> Enum.filter(fn item ->
      length(item) > 0
    end)
  end

  def draw_until_last_winner(boards, [number| rest_draws]) do
    updated_boards = Enum.map(boards, fn board ->
      stamp_number(board, number)
    end)

    winner_boards = Enum.map(updated_boards, fn board ->
      is_board_completed(board)
    end)
    case Enum.sum(winner_boards) > 0 do
      # we have a winner board
      true ->
        case length(updated_boards) > 1 do
          true ->
            remaining_boards = remove_winner_boards(updated_boards, winner_boards)
            draw_until_last_winner(remaining_boards, rest_draws)
          _ -> {updated_boards, winner_boards, number}
        end
      _ -> draw_until_last_winner(updated_boards, rest_draws)
    end
  end

  def draw_until_last_winner(boards, []) do
    {boards, [], -1}
  end
end


# Part 1
{updated_boards, winner_boards, last_number} = Bingo.draw_until_winner(board_sheet, draws)
winner_board = Bingo.first_winner_board(updated_boards, winner_boards)
unmarked_sum = Bingo.sum_unmarked(winner_board)
part1 = last_number * unmarked_sum
:io.format("Day 4 - Part 1 = ~w~n", [part1])


# Part 2
{updated_boards, winner_boards, last_number} = Bingo.draw_until_last_winner(board_sheet, draws)
winner_board = Bingo.first_winner_board(updated_boards, winner_boards)
unmarked_sum = Bingo.sum_unmarked(winner_board)
part2 = last_number * unmarked_sum
:io.format("Day 4 - Part 2 = ~w~n", [part2])

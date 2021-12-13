class GameController < ApplicationController

  REELS = [5, 1, 9, 10, 9, 4, 6, 5, 2, 6, 9, 4, 9, 5, 7, 3, 10, 9, 5, 10, 7, 3, 10, 9, 6, 10, 4, 6, 10, 3, 9, 5, 10, 0, 0, 12, 12, 6, 10, 1, 9, 10, 1, 6, 9, 3, 9, 10, 3, 10, 6, 9, 4, 9, 6, 10, 9, 8, 10, 4, 9, 10, 7, 4, 10, 6, 7, 10, 2, 7, 9, 7, 9],
    [7, 8, 4, 7, 6, 3, 9, 8, 1, 9, 11, 7, 4, 7, 6, 7, 3, 10, 2, 7, 8, 10, 2, 9, 4, 7, 11, 10, 2, 8, 11, 8, 9, 4, 10, 11, 4, 8, 5, 8, 3, 10, 5, 3, 5, 8, 5, 4, 10, 3, 7, 5, 4, 7, 5, 1, 0, 0, 0, 12, 10, 11, 7, 10, 4, 7, 6, 7, 2, 8, 6, 7, 2, 8, 12, 12, 10, 1, 6, 10, 11, 5, 9, 6, 1, 5, 6, 9, 2, 6, 5, 6, 3, 7, 9, 7, 2, 9, 5, 9, 3, 5, 7, 4, 5, 7, 9],
    [3, 8, 1, 7, 4, 8, 3, 8, 2, 9, 9, 10, 10, 8, 11, 3, 5, 4, 8, 1, 8, 3, 8, 3, 5, 1, 8, 3, 2, 1, 5, 3, 8, 4, 8, 3, 8, 1, 8, 1, 11, 2, 5, 3, 8, 1, 8, 4, 12, 0, 0, 12, 1, 8, 2, 9, 2, 8, 3, 8, 2, 8, 1, 7, 3, 6, 4, 10, 1, 11, 8, 1, 7],
    [4, 9, 4, 10, 2, 0, 0, 0, 0, 5, 11, 4, 8, 1, 9, 6, 2, 5, 4, 7, 11, 7, 2, 7, 4, 7, 10, 1, 7, 4, 10, 11, 7, 2, 6, 2, 9, 4, 6, 2, 8, 2, 9, 1, 10, 4, 8, 7, 7, 7, 10, 2, 8, 2, 9, 4, 8, 10, 2, 7, 4, 9, 8, 2, 10, 6, 3, 9, 2, 10, 12, 12, 12, 2, 10, 3, 10, 3, 5, 4, 10, 2, 8, 1, 9, 3, 6, 4, 10, 3, 8, 4, 9, 1, 10, 4, 10, 1, 5, 7, 9],
    [2, 7, 10, 1, 8, 3, 10, 6, 2, 10, 7, 3, 6, 10, 1, 7, 6, 5, 2, 10, 2, 7, 3, 7, 3, 10, 9, 5, 4, 5, 8, 2, 9, 6, 3, 6, 0, 0, 0, 0, 1, 6, 2, 5, 4, 8, 9, 3, 7, 6, 2, 5, 6, 9, 4, 5, 6, 1, 9, 3, 7, 2, 8, 3, 6, 9, 4, 5, 1, 8, 4, 6, 3, 6, 0, 12, 12, 12, 12, 7, 2, 7, 12, 10, 1, 5, 2, 6, 1, 8, 2, 6, 5, 7, 9]

  WIN_LINES = [
    "1 1 1 1 1",
    "2 2 2 2 2",
    "0 0 0 0 0",
    "3 3 3 3 3",
    "1 2 3 2 1",
    "2 1 0 1 2",
    "0 0 1 2 3",
    "3 3 2 1 0",
    "1 0 0 0 1",
    "2 3 3 3 2",
    "0 1 2 3 3",
    "3 2 1 0 0",
    "1 0 1 2 1",
    "2 3 2 1 2",
    "0 1 0 1 0",
    "3 2 3 2 3",
    "1 2 1 0 1",
    "2 1 2 3 2",
    "0 1 1 1 0",
    "3 2 2 2 3"
  ]

  PAYOUT_TABLE = {
    "0" => "0 50 200 1000",
    "1" => "0 25 100 400",
    "2" => "0 25 100 400",
    "3" => "0 20 75 250",
    "4" => "0 20 75 250",
    "5" => "0 5 50 150",
    "6" => "0 5 50 150",
    "7" => "0 5 20 100",
    "8" => "0 5 20 100",
    "9" => "0 5 20 100",
    "10" => "0 5 20 100"
  }

  @@reels_array = Array.new()
  @@game = GameController.new()

  def index
    @@reels_array = @@game.spin(REELS)
    @reels_array = @@reels_array
    render "game/game"
  end

  def spin (array)
    result = Array.new()
    i = 0
    array.each do |column|
      random_index = rand(column.length - 4)
      result[i] = column[random_index..random_index + 3]
      i = i + 1
    end
    return result.transpose
  end

  def Play

    @win_multiplier = 0
    @reels_array = @@reels_array

    WIN_LINES.each do |line|
      template = line.split(" ").map(&:to_i)
      temp_win_multi = 1
      numbers_in_row = 0
      first_element = 13
      symbol_for_check = 13
      @@reels_array.transpose.each_with_index do |row, i|
        j = template[i]
        if first_element == 13
          row[j] != 11 ? first_element = row[j] : temp_win_multi = 0
          next
        elsif temp_win_multi != 0
          check = row[j]
          if first_element == 12 and check != 12
            first_element = check
            numbers_in_row += 1
            symbol_for_check = check
          elsif check == 12
            numbers_in_row += 1
          elsif first_element == check
            numbers_in_row += 1
            symbol_for_check = check
          else
            break
          end
        else
          break
        end
      end
      if symbol_for_check != 13 and numbers_in_row > 1
        @win_multiplier += @@game.check_paytable(symbol_for_check, numbers_in_row)
      end
    end
    if @win_multiplier != 0
      render('game/win')
    else
      render('game/lose')
    end
  end

  def check_paytable(symbol, numbers_in_row)
    return PAYOUT_TABLE.values_at(symbol.to_s)[0].split(" ").map(&:to_i)[numbers_in_row]
  end
end

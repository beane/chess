class Player
  attr_reader :color

  def initialize(color)
    @color = color
  end
end

class HumanPlayer < Player
  COLUMNS = { "a" => 0,
              "b" => 1,
              "c" => 2,
              "d" => 3,
              "e" => 4,
              "f" => 5,
              "g" => 6,
              "h" => 7 }

  def format_position(position)
    col_letter = position[0]
    row = position[1]

    #either of the digits could be a letter
    if ("a".."h") === position[1]
      #second digit is the letter
      col_letter = position[1]
      row = position[0]
    end

    raise InvalidPositionError unless ("a".."h") === col_letter

    col = COLUMNS[col_letter]
    row = row.to_i-1 # Integer(row) can throw an error that we can rescue

    raise InvalidPositionError unless (0...8) === row

    [row, col]
  end

  def get_move
    begin
      printf "Type in your move, #{self.color} (start,end): "
      str_input = gets.downcase.chomp.split(",")

      row1, col1 = str_input[0].split('')

      return [format_position([row1, col1])] if str_input.size == 1
      raise InvalidPositionError unless str_input.size == 2

      row2, col2 = str_input[1].split('')

      start = format_position([row1, col1])
      final = format_position([row2, col2])

      system("clear") # might want move around (passing stuff to errors?)

      [start, final]
    rescue InvalidPositionError => e
      puts e.message()
      retry
    rescue WrongPieceError => e
      puts e.message(current_player)
      retry
    end
  end
end

class ComputerPlayer < Player

end
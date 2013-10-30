class Game
  COLUMNS = { "a" => 0,
              "b" => 1,
              "c" => 2,
              "d" => 3,
              "e" => 4,
              "f" => 5,
              "g" => 6,
              "h" => 7 }

  def initialize

  end

  def format_position(str_pos)

  end

  def prompt_user
    puts "Type in your move"
    str_input = gets.downcase.chomp

    #raise error if str_input is not 2 digits

    col_letter = str_input[0]
    row = str_input[1]

    #either of the digits could be a letter
    if ("a".."h") === str_input[1]
      #second digit is the letter
      col_letter = str_input[1]
      row = str_input[0]
    else

    end

    col = COLUMNS[col_letter]
    row = row.to_i



  end

end
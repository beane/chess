class MoveError < ArgumentError
  #generic error parent class
  def message(*args)
    "You can't move to that square. Try again!"
  end
end

class MoveIntoCheckError < MoveError
  #this move puts player in check
  def message
    "That puts you in check! Try again!"
  end
end

class StartPositionError < MoveError
  #Move tries to move a nil piece
  def message
    "There's no piece in the first position!\nTry again!"
  end
end

class InvalidPositionError < MoveError
  #Move is off the board
  def message
    "One of those positions is invalid."
  end
end

class EndPositionError < MoveError
  #Piece cannot move to end position
  def message
    "You can't move your piece to that square\nTry again."
  end
end

class WrongPieceError < MoveError
  #Piece cannot be moved by current player
  def message(color)
    "That's not your piece!\nTry one of your own #{color.to_s.upcase} pieces."
  end
end

class ShowMoves < MoveError


end

class QuitGame < StandardError

end
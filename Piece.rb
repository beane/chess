class Piece
  def initialize(pos, board, color)
    @pos, @board, @color = pos, board, color
  end

  def moves # returns array of possible moves
    possible_moves = []

    possible_moves
  end

  def move(end_position) # modifies pos and board, maybe
    self.pos = end_position
  end


  private
    attr_accessor :pos, :board, :color

end
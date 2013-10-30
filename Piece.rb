class Piece
  attr_accessor :pos
  attr_reader :color

  ORTHOGONAL_DELTAS = [[]]


  def initialize(pos, board, color)
    @pos, @board, @color = pos, board, color
  end

  def move(end_position) # modifies pos and board, maybe
    self.pos = end_position
  end

  def move_into_check?(final)
    temp_board = self.board.dup
    temp_board.move!(self.pos, final)

    temp_board.checked?(self.color)
  end

  def dup(new_board)
    row = self.pos[0]
    col = self.pos[1]
    new_pos = [row, col]

    #WRONG calling @board
    #self.class.new(new_pos, @board, @color)
    self.class.new(new_pos, new_board, @color)
  end

  def to_s
    "P"
  end

  def legal_move?(position)
    return false if position.any? {|coord| !coord.between?(0,7)}

    piece = self.board[position]

    return true if piece.nil?

    (piece.color != self.color) ? true : false
  end

  protected
  attr_reader :board
end
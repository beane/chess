#require 'debugger'

class Piece
  attr_accessor :color, :pos, :board

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

  def dup
    row = self.pos[0]
    col = self.pos[1]
    new_pos = [row, col]

    self.class.new(new_pos, @board, @color)
  end

  def to_s
    "P"
  end

  def legal_move?(position)
    piece = board[position]

    return false if position.any? {|coord| !coord.between?(0,7)}
    return true if piece.nil?

    if piece.color == self.color
      false
    else
      true
    end
  end

  protected
    #attr_accessor :color, :pos, :board

  private
    #attr_accessor

end

class SlidingPiece < Piece
  attr_reader :pos, :color
  def initialize(pos, board, color, type)
    super(pos, board, color)

    @type = type #Diagonal, orthogonal, both
  end


  def moves
    return orthogonal_moves if self.type == :orthogonal
    return diagonal_moves if self.type == :diagonal
    return orthogonal_moves + diagonal_moves if self.type == :both
  end

  protected
    attr_reader :type

  private
    attr_accessor :board

    def vertical_moves(row, col, inc)
      if !(row).between?(0,7)
        return []
      elsif [row, col] == self.pos
        vertical_moves(row+inc, col, inc)
      elsif board[[row,col]]
        return [] if board[[row,col]].color == self.color
        return [[row,col]] if board[[row,col]] != self.color
      else
        vertical_moves(row+inc, col, inc) + [[row,col]]
      end
    end

    def horizontal_moves(row, col, inc)
      if !(col).between?(0,7)
        return []
      elsif [row, col] == self.pos
        horizontal_moves(row, col+inc, inc)
      elsif board[[row,col]]
        return [] if board[[row,col]].color == self.color
        return [[row,col]] if board[[row,col]] != self.color
      else
        horizontal_moves(row, col+inc, inc) + [[row,col]]
      end
    end

    def negative_diagonal_moves(row, col, inc)
      if !(col).between?(0,7) || !(row).between?(0,7)
        return []
      elsif [row, col] == self.pos
        negative_diagonal_moves(row+inc, col+inc, inc)
      elsif board[[row,col]]
        return [] if board[[row,col]].color == self.color
        return [[row,col]] if board[[row,col]] != self.color
      else
        negative_diagonal_moves(row+inc, col+inc, inc) + [[row,col]]
      end
    end

    def positive_diagonal_moves(row, col, inc)
      if !(col).between?(0,7) || !(row).between?(0,7)
        return []
      elsif [row, col] == self.pos
        positive_diagonal_moves(row-inc, col+inc, inc)
      elsif board[[row,col]]
        return [] if board[[row,col]].color == self.color
        return [[row,col]] if board[[row,col]] != self.color
      else
        positive_diagonal_moves(row-inc, col+inc, inc) + [[row,col]]
      end
    end

    def orthogonal_moves()
      row, col = pos

      orthogonal_moves = []
      orthogonal_moves += vertical_moves(row, col, 1)
      orthogonal_moves += vertical_moves(row, col, -1)
      orthogonal_moves += horizontal_moves(row, col, 1)
      orthogonal_moves += horizontal_moves(row, col, -1)

      orthogonal_moves
    end

    def diagonal_moves()
      row, col = pos

      diagonal_moves = []
      diagonal_moves += positive_diagonal_moves(row, col, 1)
      diagonal_moves += positive_diagonal_moves(row, col, -1)
      diagonal_moves += negative_diagonal_moves(row, col, 1)
      diagonal_moves += negative_diagonal_moves(row, col, -1)

      diagonal_moves
    end
end

class SteppingPiece < Piece
  def initialize(pos, board, color, deltas)
    super(pos, board, color)

    @deltas = deltas
  end

  def moves
    possible_moves = []
    @deltas.each do |d_row, d_col|
      row, col = d_row + pos[0], d_col + pos[1]
      possible_moves << [row, col] if legal_move?([row, col])
    end

    possible_moves
  end
end

class Knight < SteppingPiece
  DELTAS = [  [-2, -1],
              [-2,  1],
              [-1, -2],
              [-1,  2],
              [ 1, -2],
              [ 1,  2],
              [ 2, -1],
              [ 2,  1] ]

  attr_accessor :pos, :color

  def initialize(pos, board, color)
    super(pos, board, color, DELTAS)
  end

  def to_s
    "N"
  end
end

class King < SteppingPiece
  DELTAS = [  [0, -1],
              [0,  1],
              [-1, -1],
              [-1,  1],
              [-1,  0],
              [1, -1],
              [1,  0],
              [1, 1] ]

  attr_accessor :pos, :color

  def initialize(pos, board, color)
    super(pos, board, color, DELTAS)
  end

  def to_s
    "K"
  end
end

class Rook < SlidingPiece

  def initialize(pos, board, color)
    super(pos, board, color, :orthogonal)
  end

  def to_s
    "R"
  end
end

class Queen < SlidingPiece
  attr_accessor :color, :pos, :board

  def initialize(pos, board, color)
    super(pos, board, color, :both)
  end

  def to_s
    "Q"
  end
end

class Bishop < SlidingPiece

  def initialize(pos, board, color)
    super(pos, board, color, :diagonal)
  end

  def to_s
    "B"
  end

end

class Pawn < Piece
  attr_accessor :pos, :board, :color
  def initialize(pos, board, color)
    super(pos, board, color)
  end

  def to_s
    "p"
  end
end
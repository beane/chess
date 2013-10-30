require_relative 'movement_classes'

class Knight < SteppingPiece
  DELTAS = [  [-2, -1],
              [-2,  1],
              [-1, -2],
              [-1,  2],
              [ 1, -2],
              [ 1,  2],
              [ 2, -1],
              [ 2,  1] ]

  def initialize(pos, board, color)
    super(pos, board, color, DELTAS)
  end

  def to_s
    self.color == :white ? "N" : 'n'
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

  def initialize(pos, board, color)
    super(pos, board, color, DELTAS)
  end

  def to_s
    self.color == :white ? "K" : 'k'
  end
end

class Rook < SlidingPiece

  def initialize(pos, board, color)
    super(pos, board, color, :orthogonal)
  end

  def to_s
    self.color == :white ? "R" : 'r'
  end
end

class Queen < SlidingPiece

  def initialize(pos, board, color)
    super(pos, board, color, :both)
  end

  def to_s
    self.color == :white ? "Q" : 'q'
  end
end

class Bishop < SlidingPiece

  def initialize(pos, board, color)
    super(pos, board, color, :diagonal)
  end

  def to_s
    self.color == :white ? "B" : 'b'
  end

end

class Pawn < Piece
  def initialize(pos, board, color)
    super(pos, board, color)
    @first_move = true
    @direction = (self.color == :white ? 1 : -1)
  end

  def first_move?
    @first_move
  end

  def forward_positions
    # trying to return
    deltas_to_check = [
      [self.direction, 0]
    ]

    deltas_to_check << [2 * self.direction, 0] if self.first_move?

    deltas_to_check.map do |d_row, d_col|
      [d_row+self.pos[0], d_col+self.pos[1]]
    end
  end

  def attack_positions# needs a map with the current pos
    [[self.direction, 1], [self.direction, -1]].map do |d_row, d_col|
      [d_row+self.pos[0], d_col+self.pos[1]]
    end
  end

  def moves_ahead
    ahead = []
    forward_positions.each do |pos|
      piece = self.board[pos]

      if self.board[pos].nil?
        ahead << pos
      else
        break
      end
    end

    ahead
  end

  def moves_diag
    diag = []
    attack_positions.each do |pos|
      piece = self.board[pos]
      next if piece.nil?
      diag << pos if piece.color != self.color
    end

    diag
  end

  def valid_moves
    moves_ahead + moves_diag
  end

  def move(end_position)
    super(end_position)
    @first_move = false
  end

  def to_s
    self.color == :white ? "P" : "p"
  end

  protected

  attr_reader :direction
end
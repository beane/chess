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
    super(pos, board, color)
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
    super(pos, board, color)
    @first_move = true
  end

  def rook(side) # returns the rook on the specified side of the king
    row = (color == :white ? 0: 7)

    if side == :queen
      self.board[[row,0]]
    else
      self.board[[row,7]]
    end
  end

  def castling_position(side)
    row = (color == :white ? 0: 7)
    col = (side == :king ? 6 : 2)

    [row, col]
  end

  # if we castle this method modifies the board class to move the rook
  def move(pos)
    super(pos)

    if self.first_move
      if castling_position(:king) == pos
        row, col = self.pos[0], 5
        rook_pos = rook(:king).pos
        self.board.move!(rook_pos, [row, col])

      elsif castling_position(:queen) == pos
        row, col = self.pos[0], 3
        rook_pos = rook(:queen).pos
        self.board.move!(rook_pos, [row, col])
      end
    end

    @first_move = false
  end

  def clear_to_rook?(side)
    row = self.pos[0]
    if side == :king
      (5..6).to_a.all? { |col| self.board[[row, col]].nil? }
    else
      (1..3).to_a.all? { |col| self.board[[row, col]].nil? }
    end
  end

  def okay_to_castle?(side)
    return false unless clear_to_rook?(side)

    rook = rook(side)
    return false unless rook.is_a?(Rook)
    return false unless rook.first_move
    return false unless self.first_move

    !self.board.checked?(self.color) # you can't move while in check
  end

  def valid_moves
    results = []
    results << castling_position(:king) if okay_to_castle?(:king)
    results << castling_position(:queen) if okay_to_castle?(:queen)

    super + results
  end

  def dup(new_board)
    new_piece = super
    new_piece.first_move = self.first_move
  end

  def to_s
    self.color == :white ? "K" : 'k'
  end

  protected
  attr_accessor :first_move
end

class Rook < SlidingPiece
  attr_reader :first_move

  def initialize(pos, board, color)
    super(pos, board, color)
    @first_move = true
  end

  def valid_moves
    orthogonal_moves
  end

  def move(position)
    super(position)
    self.first_move = false
  end

  def dup(new_board)
    new_piece = super
    new_piece.first_move = self.first_move
  end

  def to_s
    self.color == :white ? "R" : 'r'
  end

  protected
  attr_writer :first_move

end

class Queen < SlidingPiece

  def initialize(pos, board, color)
    super(pos, board, color)
  end

  def valid_moves
    orthogonal_moves + diagonal_moves
  end

  def to_s
    self.color == :white ? "Q" : 'q'
  end
end

class Bishop < SlidingPiece

  def initialize(pos, board, color)
    super(pos, board, color)
  end

  def valid_moves
    diagonal_moves
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

  def move(final)
    super(final)

    @first_move = false
    row, col = self.pos

    if row == 0 || row == 7
      self.board.promote_pawn(self.color, self.pos)
    end
  end

  def forward_positions
    deltas_to_check = [[self.direction, 0]]

    deltas_to_check << [2 * self.direction, 0] if self.first_move?

    deltas_to_check.map do |d_row, d_col|
      [d_row + self.pos[0], d_col + self.pos[1]]
    end
  end

  def attack_positions
    [[self.direction, 1], [self.direction, -1]].map do |d_row, d_col|
      [d_row+self.pos[0], d_col+self.pos[1]]
    end
  end

  def moves_ahead
    ahead = []
    forward_positions.each do |pos|

      self.board[pos].nil? ? ahead << pos : break
      # if self.board[pos].nil?
      #   ahead << pos
      # else
      #   break
      # end
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



  def to_s
    self.color == :white ? "P" : "p"
  end

  protected

  attr_reader :direction
end
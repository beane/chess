require_relative 'board'
### NOT FUNCTIONAL YET
#   Check out forward_moves and diag_moves
#   Make sure that forward_moves stops when it encounters
#   Any piece, and doesn't add the square after that
#   (That only matters in rare cases)
class Pawn < Piece
  def initialize(pos, board, color)
    super(pos, board, color)
    @first_move = true
    @direction = (self.color == :white ? 1 : -1)
  end

  def first_move?
    @first_move
  end

  def forward_moves
    # trying to return
    deltas_to_check = [
      [self.direction, 0]
    ]

    deltas_to_check << [2 * self.direction, 0] if self.first_move?

    deltas_to_check.map do |pos|
      row, col = pos
      [row+self.pos[0], col+self.col[0]]
    end
  end

  def diag_moves # needs a map with the current pos
    [[self.direction, 1], [self.direction, -1]]
  end

  def moves_ahead
    ahead = []
    forward_deltas.each do |pos|

      piece = self.board[pos]
      ahead << pos if self.board[pos].nil?
    end

    ahead
  end

  def moves_diag
    diag = []
    diag_deltas.each do |pos|
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
    "p"
  end

  protected

  attr_reader :direction
end

if $PROGRAM_NAME == __FILE__
  b = ChessBoard.new
  b.place!([0,4],[2,2])
  b.place!([0,3], [2,0])
  p = Pawn.new([1,1], b, :white)
  b.add_piece(p)
  p b
  p p.valid_moves
end
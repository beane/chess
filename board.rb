require_relative "piece"
require 'debugger'

class Board
  attr_accessor :board
  def initialize
    @board = (0...8).map { (0...8).map {nil} }
    @white_piece = setup(:white)
    @black_pieces = setup(:black)
  end

  def setup(color)
    # places pieces on board and returns an array of those pieces
    row = (color == :white) ? 0 : 7
    pawn_offset = (color == :white) ? 1 : -1

    k = King.new([row, 4], self, color)
    self[[row,4]] = k

    q = Queen.new([row, 3], self, color)
    self[[row,3]] = q

    b1 = Bishop.new([row, 2], self, color)
    b2 = Bishop.new([row, 5], self, color)
    self[[row,2]] = b1
    self[[row,5]] = b2

    k1 = Knight.new([row, 1], self, color)
    k2 = Knight.new([row, 6], self, color)
    self[[row,1]] = k1
    self[[row,6]] = k2

    r1 = Rook.new([row, 0], self, color)
    r2 = Rook.new([row, 7], self, color)
    self[[row,0]] = r1
    self[[row,7]] = r2

    pieces = [k, q, k1, k2, b1, b2, r1, r2]

    8.times do |col|
      p_row = row+pawn_offset
      p = Pawn.new([p_row, col], self, color)
      self[[p_row,col]] = p
      pieces << p
    end

    pieces
  end

  def [] (pos)
    row, col = pos
    @board[row][col]
  end

  def []= (pos, value)
    row, col = pos
    @board[row][col] = value
  end

  def add_piece(piece)
    self[piece.pos] = piece
  end

  def update!(positions)
    positions.each do |pos|
      self[pos] = "*"
    end
  end

  def to_s
    str = ""
    @board.each do |r|
      r.each do |c|
        if c.nil?
          str += "- "
        else
          str += c.to_s + " "
        end
      end
      str += "\n"
    end

    str
  end
end

# debugger

board1 = Board.new()
# q = SlidingPiece.new([2,7], board1, :black, :both)
# k = Knight.new([4,8], board1, :white)
# k1 = King.new([5,7], board1, :white)
#
# board1.add_piece(k)
# board1.add_piece(q)
# board1.add_piece(k1)
#
k1 = board1[[0,3]]
arr = k1.moves
p arr
board1.update!(arr)
puts board1
require_relative "piece"
require 'debugger'

class ChessBoard
  class BadMoveError < ArgumentError
  end

  attr_accessor :board

  def initialize
    @board = (0...8).map { (0...8).map {nil} }
    @white_pieces = setup(:white)
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

  def checked?(color)

    player = @black_pieces
    other_player = @white_pieces

    if color == :white
      player = @white_pieces
      other_player = @black_pieces
    end

    king_pos = player[0].pos

    temp_board = self.dup
    other_player.each do |piece|
      return true if piece.moves.include?(king_pos)
    end

    false
  end

  def [](pos)
    row, col = pos
    return nil unless row.between?(0,7)
    @board[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @board[row][col] = value
  end

  def add_piece(piece)
    self[piece.pos] = piece
  end

  def move(start, final)
    raise BadMoveError if self[start].nil?
    #raise if wrong color

    piece = self[start]

    raise BadMoveError unless piece.moves.include?(final)

    self[final] = piece
    piece.move(final)

    self[start] = nil
  end

  def dup
    new_board = ChessBoard.new

    board.each_with_index do |row, index|

      new_row = []
      row.each do |piece|
        if piece.nil?
          new_row << piece
        else
          new_row << piece.dup
         end
      end

      new_board.board[index] = new_row
    end

    new_board
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

#board1 = ChessBoard.new()
#q = board1[[0,3]]
#q.move([1,4])

# debugger
#q = board1[[0,4]]
#p board1
#board1.move([0,3],[3,0])
#p board1.checked?(:black)
#p board1

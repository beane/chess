require_relative "piece"
require 'debugger'

class ChessBoard
  class BadMoveError < ArgumentError
  end
  class MoveIntoCheckError < BadMoveError
  end

  attr_accessor :board

  def initialize
    @board = (0...8).map { (0...8).map {nil} }
  end

  def get_pieces(color)
    self.board.flatten.select do |piece|
      next if piece.nil?
      piece.color == color
    end
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
    #
    # 8.times do |col|
    #   p_row = row+pawn_offset
    #   p = Pawn.new([p_row, col], self, color)
    #   self[[p_row,col]] = p
    #   pieces << p
    # end

    pieces
  end

  def show_moves(position)
    possible_moves = self[position].valid_moves

    temp_board = self.dup

    possible_moves.each do |pos|
      temp_board[pos] = "*"
    end

    p temp_board
  end

  def checked?(color)
    king_pos = get_pieces(color).select { |piece| piece.is_a?(King) }.first.pos

    opposite_color = color == :black ? :white : :black
    get_pieces(opposite_color).each do |piece|
      #debugger if piece.is_a?(Queen)
      return true if piece.valid_moves.include?(king_pos)
    end

    false
  end

  def checkmate?(color)
    return false unless checked?(color)

    get_pieces(color).all? { |piece| piece.valid_moves.empty? }

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
    piece = self[start]

    #puts piece.color
    raise BadMoveError unless piece.valid_moves.include?(final)

    #debugger
    raise MoveIntoCheckError if piece.move_into_check?(final)

    self[final] = piece
    piece.move(final)
    #puts "#{piece} moved to #{final}"

    self[start] = nil
  end

  def move!(start, final)
    raise BadMoveError if self[start].nil?
    piece = self[start]
    raise BadMoveError unless piece.valid_moves.include?(final)


    self[final] = piece
    piece.move(final)

    #puts "#{piece} moved to #{final}"
    self[start] = nil
  end

  def dup
    new_board = ChessBoard.new

    board.each_with_index do |row, index_r|
      new_row = []
      row.each_with_index do |piece, index_c|
        if piece.nil?
          new_row << nil
        else
          new_row << piece.class.new([index_r,index_c], new_board, piece.color)
        end
      end

      new_board.board[index_r] = new_row
    end

    new_board
  end

  def place!(start, final)
     raise BadMoveError if self[start].nil?
    piece = self[start]

    self[final] = piece
    piece.move(final)

    self[start] = nil
  end

  def update!(positions)
    positions.each do |pos|
      self[pos] = "*"
    end
  end

  def start_game()
    setup(:white)
    setup(:black)
  end

  def to_s
    #str =  "| | A B C D E F G H |\n"
    str =  "| | 0 1 2 3 4 5 6 7 |\n"
    str += "| |-----------------|\n"

    8.times { |num| }
    @board.each_with_index do |row, index|
      str += "|#{index}| "
      row.each do |entry|
        if entry.nil?
          str += "- "
        else
          str += entry.to_s + " "
        end
      end

      str += "|\n"
    end

    str += "| |-----------------|\n"
    str
  end
end

if $PROGRAM_NAME == __FILE__
  puts "IN BOARD"
  board1 = ChessBoard.new()
  board1.start_game()
  p board1


  #debugger
  board1.move([0,3],[1,4])
  p board1

  #p board1.show_moves([1,4])
  board1.move([7,3], [6,4])
  #debugger
  p board1

  board1.place!([7,2],[3,2])

  board1.show_moves([3,2])
  p board1
  #board1.move([6,4],[7,3])
  #p board1
end
require 'debugger'
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

  def to_s
    "P"
  end

  def legal_move?(position)
    piece = board[position]

    return true if piece.nil?
    if piece.color == self.color
      false
    else
      true
    end
  end

  private
    attr_accessor :pos, :board, :color

end

class SlidingPiece < Piece
  attr_reader :pos, :color
  def initialize(pos, board, color, type)
    super(pos, board, color)

    @type = type #Diagonal, orthogonal, both
  end


  def moves
    orthogonal_moves if self.type == :orthogonal
    diagonal_moves if self.type == :diagonal
    orthogonal_moves + diagonal_moves if self.type == :both
  end

  protected
    attr_reader :type

  private
    attr_accessor :board



    def vertical_moves(row, col, inc)
      if !(row+inc).between?(0,8)
        return []
      elsif [row, col] == self.pos
        vertical_moves(row+inc, col, inc)
      elsif board[[row,col]]
        return [] if board[[row,col]].color == self.color
        return [[row,col]] if board[[row,col]] != self.color
      else
        vertical_moves(row+inc, col, inc) + [[row+inc,col]]
      end
    end

    def horizontal_moves(row, col, inc)
      if !(col+inc).between?(0,8)
        return []
      elsif [row, col] == self.pos
        horizontal_moves(row, col+inc, inc)
      elsif board[[row,col]]
        return [] if board[[row,col]].color == self.color
        return [[row,col]] if board[[row,col]] != self.color
      else
        horizontal_moves(row, col+inc, inc) + [[row,col+inc]]
      end
    end

    def negative_diagonal_moves(row, col, inc)
      if !(col+inc).between?(0,8) || !(row+inc).between?(0,8)
        return []
      elsif [row, col] == self.pos
        negative_diagonal_moves(row+inc, col+inc, inc)
      elsif board[[row,col]]
        return [] if board[[row,col]].color == self.color
        return [[row,col]] if board[[row,col]] != self.color
      else
        negative_diagonal_moves(row+inc, col+inc, inc) + [[row+inc,col+inc]]
      end
    end

    def positive_diagonal_moves(row, col, inc)
      if !(col+inc).between?(0,8) || !(row-inc).between?(0,8)
        return []
      elsif [row, col] == self.pos
        positive_diagonal_moves(row-inc, col+inc, inc)
      elsif board[[row,col]]
        return [] if board[[row,col]].color == self.color
        return [[row,col]] if board[[row,col]] != self.color
      else
        positive_diagonal_moves(row-inc, col+inc, inc) + [[row-inc,col+inc]]
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

end

class Board
  attr_accessor :board
  def initialize
    @board = (0..8).map { (0..8).map {nil} }
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

board1 = Board.new()
q = SlidingPiece.new([3,7], board1, :white, :both)
k = Knight.new([4,8], board1, :white)

# board1.add_piece(k)
board1.add_piece(q)
debugger
arr = q.moves
board1.update!(arr)
p arr
puts board1
#p a.horizontal_moves(1,2,1)
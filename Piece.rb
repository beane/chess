#require 'debugger'
class Piece
  attr_accessor :pos
  attr_reader :color

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

class SlidingPiece < Piece
  def initialize(pos, board, color, type)
    super(pos, board, color)

    @type = type #Diagonal, orthogonal, both
  end


  def valid_moves
    result = orthogonal_moves if self.type == :orthogonal
    result = diagonal_moves if self.type == :diagonal
    result = orthogonal_moves + diagonal_moves if self.type == :both

    result
  end

  protected
    attr_reader :type

    # def vertical_moves(row, col, inc)
    #   return [] if !(row).between?(0,7)
    #   return vertical_moves(row+inc, col, inc) if [row, col] == self.pos
    #
    #   if board[[row,col]]
    #     return [] if board[[row,col]].color == self.color
    #     return [[row,col]] if board[[row,col]] != self.color
    #   else
    #     vertical_moves(row+inc, col, inc) + [[row,col]]
    #   end
    # end
    #
    # def horizontal_moves(row, col, inc)
    #   if !(col).between?(0,7)
    #     return []
    #   elsif [row, col] == self.pos
    #     horizontal_moves(row, col+inc, inc)
    #   elsif board[[row,col]]
    #     return [] if board[[row,col]].color == self.color
    #     return [[row,col]] if board[[row,col]] != self.color
    #   else
    #     horizontal_moves(row, col+inc, inc) + [[row,col]]
    #   end
    # end
    #
    # def negative_diagonal_moves(row, col, inc)
    #   if !(col).between?(0,7) || !(row).between?(0,7)
    #     return []
    #   elsif [row, col] == self.pos
    #     negative_diagonal_moves(row+inc, col+inc, inc)
    #   elsif board[[row,col]]
    #     return [] if board[[row,col]].color == self.color
    #     return [[row,col]] if board[[row,col]] != self.color
    #   else
    #     negative_diagonal_moves(row+inc, col+inc, inc) + [[row,col]]
    #   end
    # end
    #
    # def positive_diagonal_moves(row, col, inc)
    #   if !(col).between?(0,7) || !(row).between?(0,7)
    #     return []
    #   elsif [row, col] == self.pos
    #     positive_diagonal_moves(row-inc, col+inc, inc)
    #   elsif board[[row,col]]
    #     return [] if board[[row,col]].color == self.color
    #     return [[row,col]] if board[[row,col]] != self.color
    #   else
    #     positive_diagonal_moves(row-inc, col+inc, inc) + [[row,col]]
    #   end
    # end
    #
    # def orthogonal_moves_orig()
    #   row, col = pos
    #
    #   #debugger if self.class == Queen
    #
    #   orthogonal_moves = []
    #   orthogonal_moves += vertical_moves(row, col, 1)
    #   orthogonal_moves += vertical_moves(row, col, -1)
    #   orthogonal_moves += horizontal_moves(row, col, 1)
    #   orthogonal_moves += horizontal_moves(row, col, -1)
    #
    #   orthogonal_moves
    # end
    #
    # def diagonal_moves_orig()
    #   row, col = pos
    #
    #   diagonal_moves = []
    #   diagonal_moves += positive_diagonal_moves(row, col, 1)
    #   diagonal_moves += positive_diagonal_moves(row, col, -1)
    #   diagonal_moves += negative_diagonal_moves(row, col, 1)
    #   diagonal_moves += negative_diagonal_moves(row, col, -1)
    #
    #   diagonal_moves
    # end

    def find_neighbors(row_offset, col_offset, position)
      row, col = position[0], position[1]
      next_position = [row+row_offset, col+col_offset]

      return find_neighbors(row_offset, col_offset, next_position) if position == self.pos
      return [] if !(col).between?(0,7)
      return [] if !(row).between?(0,7)

      if board[position]
        return [] if board[position].color == self.color
        return [position] if board[position].color != self.color
      end

      [position] + find_neighbors(row_offset, col_offset, next_position)
    end

    def orthogonal_moves()
      row, col = pos

      orthogonal_moves = []
      orthogonal_moves += find_neighbors(0, 1, pos) #right
      orthogonal_moves += find_neighbors(0, -1, pos) #left

      orthogonal_moves += find_neighbors(1, 0, pos) #down
      orthogonal_moves += find_neighbors(-1, 0, pos) #up

      orthogonal_moves
    end

    def diagonal_moves()
      row, col = pos

      diagonal_moves = []
      diagonal_moves += find_neighbors(1, 1, pos) #bot-right
      diagonal_moves += find_neighbors(-1, -1, pos) #top-left
      diagonal_moves += find_neighbors(1, -1, pos) #top-right
      diagonal_moves += find_neighbors(-1, 1, pos) #bot-left

      diagonal_moves
    end
end

class SteppingPiece < Piece
  def initialize(pos, board, color, deltas)
    super(pos, board, color)

    @deltas = deltas
  end

  def valid_moves
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

if $PROGRAM_NAME == __FILE__
  # might need to require something
  # just for testing, anyway
  b = ChessBoard.new
  b.start_game()

  # b.place!([7,7],[2,2])
  # b.place!([0,3], [3,1])
  pos = [1,1]
  p = Pawn.new(pos, b, :white)
  b.add_piece(p)

  b.show_moves(pos)
  p b[pos].valid_moves
end
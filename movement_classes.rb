require_relative 'piece'

class SlidingPiece < Piece
  def initialize(pos, board, color)
    super(pos, board, color)
  end

  protected
    attr_reader :type

    def find_neighbors(row_offset, col_offset, position)
      row, col = position[0], position[1]
      next_position = [row+row_offset, col+col_offset]

      return find_neighbors(row_offset, col_offset, next_position) if position == self.pos
      return [] unless (col).between?(0,7)
      return [] unless (row).between?(0,7)

      if board[position]
        return [] if board[position].color == self.color
        return [position] unless board[position].color == self.color
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
  def initialize(pos, board, color)
    super(pos, board, color)
  end

  def valid_moves
    possible_moves = []
    self.class::DELTAS.each do |d_row, d_col|
      row, col = d_row + pos[0], d_col + pos[1]
      possible_moves << [row, col] if legal_move?([row, col])
    end

    possible_moves
  end
end
require_relative "chessboard"
require_relative "errors"
require_relative "players"

class Game
  attr_reader :chess_board, :white_player, :black_player

  def initialize
    @chess_board = ChessBoard.new
    @white_player = choose_player(:white)
    @black_player = choose_player(:black)
    @current_player = self.white_player
    chess_board.start_game
  end

  def choose_player(color)
    printf "Who plays #{color}? (h/c): "
    player = gets.chomp.downcase
    player == 'h' ? HumanPlayer.new(color) : Player.new(color)
  end

  def wrong_piece(position)
    self.chess_board[position].color != self.current_player.color
  end

  def game_turn
    begin
      puts "CHECKED!" if self.chess_board.checked?(current_player.color)
      puts self.chess_board

      start, final = self.current_player.get_move

      raise WrongPieceError if chess_board[start] && wrong_piece(start)
    rescue WrongPieceError => e
      puts e.message(current_player.color)
      retry
    end

    self.chess_board.move(start, final)
  end

  def change_player
    if current_player.color == :black
      self.current_player = white_player
    else
      self.current_player = black_player
    end
  end


  def play_game
    loop do
      begin
        game_turn

      # ALL OF THESE ERRORS SHOULD COME FROM THE BOARD
      # RAISE MOVE INTO CHECK ERROR
      rescue MoveIntoCheckError => e
        puts e.message
        retry
      rescue EndPositionError => e
        puts e.message
        retry
      rescue StartPositionError => e
        puts e.message
        retry
      end

      self.change_player

      break if chess_board.checkmate?(current_player.color)
      break if chess_board.draw?(current_player.color)
    end

  end

  def to_s
    self.chess_board.to_s
  end

  protected

  attr_accessor :current_player

end

if $PROGRAM_NAME == __FILE__
  game = Game.new
  game.play_game
end
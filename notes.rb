#
# Piece is the Parent class of all the pieces
# It takes a board, position, color
# It has a method "moves" that returns an array of its legal moves
# It has a "move" method that updates the position of the piece
# Maybe - This might also update the board class
#
# Subclasses of Piece
# SlidingPiece
#   initialize accepts direction parameter
#   Rook < SlidingPiece
#   Rook.new([x,y],self)
#
# SteppingPiece
#
#
# Board class
# holds a 2-dimension array
# values are nil or Piece object
# hold a Array for all black pieces
# hold a Array for all white pieces
#
# method "checked?(color)"
# find the king of color
# check if any of the opponent pieces can move to that square
#
# method "move(start, end)"
# look in its array for start
# check to see if start is nil?
# raise error is it is
# raise error if it's your opponent's piece
# if not:
# call piece''s move method to determine if end position is valid
# raise error if end is not valid for that piece
# move piece
#
# *** dup: duplicate the board (deep dup?) and pieces
#
#
# Piece, cont.
# valid moves: ignore the moves that leave your king in check
# move_into_check?: duplicate board and make move, the see if king is in check.
# dup: makes a new piece with the same info
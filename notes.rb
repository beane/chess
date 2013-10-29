# Maybe update recursion on sliding piece moves
# piece.stuff(prev)
# return if
#   piece.up.stuff
#   piece.down.stuff
#   piece.left.stuff
#   piece.right.stuff unless piece.right == self
# end
#
#
# piece.diag(prev)
#   piece.upleft.diag
#   piece.downleft.diag
#   piece.
# end


# Piece, cont.
# valid moves: ignore the moves that leave your king in check
# move_into_check?: duplicate board and make move, the see if king is in check.
# dup: makes a new piece with the same info

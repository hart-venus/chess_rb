# frozen_string_literal: true

# base piece class for all other pieces to inherit from.
class Piece
  attr_accessor :x_coord, :y_coord, :id, :is_white

  def initialize(id, x_coord = 0, y_coord = 0, is_white: true)
    @x_coord = x_coord
    @y_coord = y_coord
    @id = id
    @is_white = is_white
  end
end

# pawn piece
class Pawn < Piece
  attr_accessor :en_passed

  def initialize(id, x_coord = 0, y_coord = 0, is_white: true)
    super
    @en_passed = false
    @has_moved = false
    @initial_y_coord = @y_coord
  end

  def to_s
    @is_white ? '♙' : '♟'
  end

  def legal_moves(board)
    @has_moved = true if @y_coord != @initial_y_coord
    moves = []

    # first check - base straight forward movement and double move if in starting position

    if is_white
      moves.append("#{id}#{x_coord}#{y_coord - 1}")
      moves.append("#{id}#{x_coord}#{y_coord - 2}") unless @has_moved
    else
      moves.append("#{id}#{x_coord}#{y_coord + 1}")
      moves.append("#{id}#{x_coord}#{y_coord + 2}") unless @has_moved
    end

    # second check - doesn't allow moves that are blocked by other pieces.
    moves.reject! { |move| board.look_up(move[1].to_i, move[2].to_i)}

    # third check - only allows diagonal moves if they can eat a piece.
    if is_white
      moves.append("#{id}#{x_coord + 1}#{y_coord - 1}") if board.look_up(x_coord + 1, y_coord - 1) && !board.look_up(x_coord + 1, y_coord - 1).is_white 
      moves.append("#{id}#{x_coord - 1}#{y_coord - 1}") if board.look_up(x_coord - 1, y_coord - 1) && !board.look_up(x_coord - 1, y_coord - 1).is_white
    else
      moves.append("#{id}#{x_coord + 1}#{y_coord + 1}") if board.look_up(x_coord + 1, y_coord + 1) && board.look_up(x_coord + 1, y_coord + 1).is_white
      moves.append("#{id}#{x_coord - 1}#{y_coord + 1}") if board.look_up(x_coord - 1, y_coord + 1) && board.look_up(x_coord - 1, y_coord + 1).is_white
    end

    # fourth check - en passe
    lookup_pieces = [board.look_up(x_coord - 1, y_coord), board.look_up(x_coord + 1, y_coord)]
    if is_white

      lookup_pieces.each do |piece|
        moves.append("#{id}#{piece.x_coord}#{y_coord - 1}") if piece && piece.is_a?(Pawn) && piece.en_passed
      end

    else
      lookup_pieces.each do |piece|
        moves.append("#{id}#{piece.x_coord}#{y_coord + 1}") if piece && piece.is_a?(Pawn) && piece.en_passed
      end
    end
    # final check - only allows moves that are inside the board.
    moves.select! { |move| board.in_board?(move[1].to_i, move[2].to_i)}
    moves
  end
end

# Knight piece
class Knight < Piece
  def to_s
    @is_white ? '♘' : '♞'
  end
end

# Bishop piece
class Bishop < Piece
  def to_s
    @is_white ? '♗' : '♝'
  end
end

# Rook piece
class Rook < Piece
  def to_s
    @is_white ? '♖' : '♜'
  end
end

# Queen piece
class Queen < Piece
  def to_s
    @is_white ? '♕' : '♛'
  end
end

# King piece
class King < Piece
  def to_s
    @is_white ? '♔' : '♚'
  end
end

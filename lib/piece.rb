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

  def initialize(id, x_coord = 0, y_coord = 0, is_white: true)
    super
    @has_moved = false
    @initial_y_coord = @y_coord
  end

  def to_s
    @is_white ? '♙' : '♟'
  end

  def legal_moves(board)
    @has_moved = true if @y_coord != @initial_y_coord
    moves = []
    if is_white
      moves.append("#{id}#{x_coord}#{y_coord - 1}")
      moves.append("#{id}#{x_coord}#{y_coord - 2}") unless @has_moved
    else
      moves.append("#{id}#{x_coord}#{y_coord + 1}")
      moves.append("#{id}#{x_coord}#{y_coord + 2}") unless @has_moved
    end
    puts moves
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

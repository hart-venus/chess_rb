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

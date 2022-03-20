# frozen_string_literal: true

require_relative 'piece'

# extra utility for string class colorization
class String
  def bg_red
    "\e[41m#{self}\e[0m"
  end
end
# board class as a container and manager for pieces
class Board
  def initialize
    @black_pieces = [
      Rook.new('A', is_white: false),
      Knight.new('B', 1, is_white: false),
      Bishop.new('C', 2, is_white: false),
      Queen.new('D', 3, is_white: false),
      King.new('E', 4, is_white: false),
      Bishop.new('F', 5, is_white: false),
      Knight.new('G', 6, is_white: false),
      Rook.new('H', 7, is_white: false),
      Pawn.new('a', 0, 1, is_white: false),
      Pawn.new('b', 1, 1, is_white: false),
      Pawn.new('c', 2, 1, is_white: false),
      Pawn.new('d', 3, 1, is_white: false),
      Pawn.new('e', 4, 1, is_white: false),
      Pawn.new('f', 5, 1, is_white: false),
      Pawn.new('g', 6, 1, is_white: false),
      Pawn.new('h', 7, 1, is_white: false)
    ]
    @white_pieces = [
      Rook.new('A',0, 7),
      Knight.new('B', 1, 7),
      Bishop.new('C', 2, 7),
      Queen.new('D', 3,7),
      King.new('E', 4, 7),
      Bishop.new('F', 5,7),
      Knight.new('G', 6,7),
      Rook.new('H', 7, 7),
      Pawn.new('a', 0, 6),
      Pawn.new('b', 1, 6),
      Pawn.new('c', 2, 6),
      Pawn.new('d', 3, 6),
      Pawn.new('e', 4, 6),
      Pawn.new('f', 5, 6),
      Pawn.new('g', 6, 6),
      Pawn.new('h', 7, 6)
    ]
  end

  def look_up(x, y)
    pieces = @black_pieces + @white_pieces
    pieces.each do |piece|
      return piece if piece.x_coord == x && piece.y_coord == y
    end
    nil
  end

  def display
    8.times do |y|
      print "#{y} "
      8.times do |x|
        char = ' '
        char += look_up(x, y).nil? ? ' ' : look_up(x, y).to_s
        char = char.bg_red if (x + y).even?
        print char
      end
      print "\n"
    end
    print '   0 1 2 3 4 5 6 7'
  end
end


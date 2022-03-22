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
  attr_accessor :black_pieces, :white_pieces

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

  def make_move(move, white_turn)
    piece_to_move = find_piece_id(move[0], white_turn)

    # en passant check baby

    # resets the en_passed variable for the pawns that didn't
    pawns(white_turn).each { |pawn| pawn.en_passed = false}

    # sets en_passed to true if the piece just en_passed
    piece_to_move.en_passed = true if piece_to_move.is_a?(Pawn) && (piece_to_move.y_coord - move[2].to_i).abs == 2

    piece_to_move.x_coord = move[1].to_i
    piece_to_move.y_coord = move[2].to_i

    # sees is the current move is en_passant or promotion
    if piece_to_move.is_a?(Pawn)
      if piece_to_move.en_passe_move.include?(move)
        piece_to_delete = look_up(piece_to_move.x_coord, white_turn ? piece_to_move.y_coord + 1 : piece_to_move.y_coord - 1)
        white_turn ? @black_pieces.delete(piece_to_delete) : @white_pieces.delete(piece_to_delete)
      end

      if piece_to_move.y_coord.zero? || piece_to_move.y_coord == 7
        white_turn ? @white_pieces.append(Queen.new(piece_to_move.id, piece_to_move.x_coord, piece_to_move.y_coord)) : @black_pieces.append(Queen.new(piece_to_move.id, piece_to_move.x_coord, piece_to_move.y_coord, is_white: false))
        white_turn ? @white_pieces.delete(piece_to_move) : @black_pieces.delete(piece_to_move)
      end
    end


    delete_duplicates(white_turn)
  end

  def in_board?(x, y)
    return true if x.between?(0, 7) && y.between?(0, 7)
  end

  def move_legal?(move, is_white)
    return print("Input must be 3 characters long. See >help \n") unless move.length == 3
    return print("That piece doesn't exist. See >help \n") unless valid_piece?(move[0], is_white)
    return print("That's not in the board. See >help \n") unless in_board?(move[1].to_i, move[2].to_i)
    return print("That's an illegal move. \n") unless check_legal(move, is_white)
    true
  end

  private

  def pawns(white)
    return @white_pieces.select { |piece| piece.is_a? Pawn} if white

    @black_pieces.select { |piece| piece.is_a? Pawn}
  end

  def delete_duplicates(white_turn)
    pieces = white_turn ? @white_pieces : @black_pieces
    other_pieces = white_turn ? @black_pieces : @white_pieces

    piece_positions = []
    pieces.each {|piece| piece_positions.append("#{piece.x_coord}#{piece.y_coord}") }

    other_pieces.each do |piece|
      if piece_positions.include?("#{piece.x_coord}#{piece.y_coord}")
        white_turn ? @black_pieces.delete(piece) : @white_pieces.delete(piece)
      end
    end
  end

  def check_legal(move, is_white, board = self)
    piece_to_move = find_piece_id(move[0], is_white)
    piece_to_move.legal_moves(board).include?(move)
  end

  def find_piece_id(id, is_white)
    if is_white
      @white_pieces.each { |piece| return piece if piece.id == id}
    else
      @black_pieces.each { |piece| return piece if piece.id == id}
    end
  end

  def valid_piece?(id, is_white)
    ids = []
    is_white ? @white_pieces.each { |piece| ids.append(piece.id)} : @black_pieces.each { |piece| ids.append(piece.id)}
    return true if ids.include?(id)
  end

end


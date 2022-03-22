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
  attr_accessor :en_passed, :en_passe_move

  def initialize(id, x_coord = 0, y_coord = 0, is_white: true)
    super
    @en_passed = false
    @en_passe_move = []
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
    @en_passe_move = []
    if is_white

      lookup_pieces.each do |piece|
        if piece && piece.is_a?(Pawn) && piece.en_passed
          moves.append("#{id}#{piece.x_coord}#{y_coord - 1}")
          @en_passe_move.append("#{id}#{piece.x_coord}#{y_coord - 1}")
        end
      end

    else
      lookup_pieces.each do |piece|
        if piece && piece.is_a?(Pawn) && piece.en_passed
          moves.append("#{id}#{piece.x_coord}#{y_coord + 1}")
          @en_passe_move.append("#{id}#{piece.x_coord}#{y_coord + 1}")
        end
      end
    end
    moves
  end
end

# Knight piece
class Knight < Piece
  def to_s
    @is_white ? '♘' : '♞'
  end

  def legal_moves(board)
    moves = []
    offsets = [
      [2, 1], [2, -1],
      [-2, 1], [-2, -1],
      [1, 2], [1,-2],
      [-1, 2], [-1, -2]
    ]
    offsets.each do |offset|
      moves.append("#{id}#{@x_coord + (offset[0])}#{@y_coord + (offset[1])}") unless board.look_up(@x_coord + offset[0], @y_coord + offset[1]) && board.look_up(@x_coord + offset[0], @y_coord + offset[1]).is_white == @is_white
    end
    moves
  end
end

# Bishop piece
class Bishop < Piece
  def to_s
    @is_white ? '♗' : '♝'
  end

  def legal_moves(board)
    moves = []
    prog_offsets = [
      [1, 1], [1, -1],
      [-1, 1], [-1, -1]
    ]
    prog_offsets.each do |offset|
      pos = [x_coord + offset[0], y_coord + offset[1]]

      loop do
        if board.look_up(pos[0], pos[1])
          piece = board.look_up(pos[0], pos[1])
          moves.append("#{id}#{pos[0]}#{pos[1]}") if piece.is_white != @is_white
          break
        end
        break unless board.in_board?(pos[0], pos[1])

        moves.append("#{id}#{pos[0]}#{pos[1]}")
        pos = [pos[0] + offset[0], pos[1] + offset[1]]
      end
    end
    moves
  end
end

# Rook piece
class Rook < Piece
  def to_s
    @is_white ? '♖' : '♜'
  end

  def legal_moves(board)
    moves = []
    prog_offsets = [
      [0, 1], [1, 0],
      [-1, 0], [0, -1]
    ]
    prog_offsets.each do |offset|
      pos = [x_coord + offset[0], y_coord + offset[1]]

      loop do
        if board.look_up(pos[0], pos[1])
          piece = board.look_up(pos[0], pos[1])
          moves.append("#{id}#{pos[0]}#{pos[1]}") if piece.is_white != @is_white
          break
        end
        break unless board.in_board?(pos[0], pos[1])

        moves.append("#{id}#{pos[0]}#{pos[1]}")
        pos = [pos[0] + offset[0], pos[1] + offset[1]]
      end
    end
    moves
  end
end

# Queen piece
class Queen < Piece
  def to_s
    @is_white ? '♕' : '♛'
  end

  def legal_moves(board)
    moves = []
    prog_offsets = [
      [0, 1], [1, 0],
      [-1, 0], [0, -1],
      [1, 1], [1, -1],
      [-1, 1], [-1, -1]
    ]
    prog_offsets.each do |offset|
      pos = [x_coord + offset[0], y_coord + offset[1]]

      loop do
        if board.look_up(pos[0], pos[1])
          piece = board.look_up(pos[0], pos[1])
          moves.append("#{id}#{pos[0]}#{pos[1]}") if piece.is_white != @is_white
          break
        end
        break unless board.in_board?(pos[0], pos[1])

        moves.append("#{id}#{pos[0]}#{pos[1]}")
        pos = [pos[0] + offset[0], pos[1] + offset[1]]
      end
    end
    moves
  end
end

# King piece
class King < Piece
  def to_s
    @is_white ? '♔' : '♚'
  end
end

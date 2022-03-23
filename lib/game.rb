# frozen_string_literal: true

require_relative 'board'

def start_game
  game_board = Board.new
  white_turn = true

  loop do
    game_board.display
    puts "\nIt's #{white_turn ? 'white' : 'black'}'s turn."
    print '> '
    input = gets.chomp

    next unless game_board.move_legal?(input, white_turn)

    game_board.make_move(input, white_turn)
    white_turn = !white_turn

  end
end

puts 'Welcome to CHESS! enter 1 to start a new game.'
start_game if gets.chomp == '1'

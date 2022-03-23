# frozen_string_literal: true

require 'oj'
require_relative 'board'

def start_game(save: false)
  if !save
    game_board = Board.new
    white_turn = true
  else
    saved_game = Oj.load_file('save.json')
    p saved_game
    game_board = saved_game[:board]
    white_turn = saved_game[:turn]
  end

  loop do
    game_board.display
    break if game_board.no_legal_moves(white_turn)

    puts "\nIt's #{white_turn ? 'white' : 'black'}'s turn."
    print '> '
    input = gets.chomp

    case input
    when 'help'
      puts '----------------------------'
      puts 'Welcome to CHESS by a. Leyva'
      puts '----------------------------'
      puts 'commands'
      puts '----------------------------'
      puts '>help : shows this screen.'
      puts '>save : saves the game.'
      puts '----------------------------'
      puts 'controls'
      puts '----------------------------'
      puts 'move a piece: {id} {x} {y} ex: d34'
      puts 'piece ids:'
      puts '♙ lowercase a-h'
      puts '♖ A    ♕ D     ♞ G'
      puts '♘ B    ♔ E     ♜ H'
      puts '♗ C    ♝ F'
      puts '----------------------------'
      next
    when 'save'
      saved_game = { board: game_board, turn: white_turn}
      File.open('save.json', 'w') do |file|
        file << Oj.dump(saved_game)
      end
      puts 'Save successful.'
      next
    end

    next unless game_board.move_legal?(input, white_turn)

    game_board.make_move(input, white_turn)
    white_turn = !white_turn

  end

  print('Game Over!')
  if game_board.in_check?(white_turn)
    print("#{white_turn ? 'black' : 'white'} wins by checkmate.")
  else
    print('By stalemate')
  end

end

puts 'Welcome to CHESS! enter 1 to start a new game, and 2 to load'

case gets.chomp
when '1'
  start_game
when '2'
  start_game(save: true)
end

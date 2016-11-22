require_relative 'board'
require_relative 'tile'
require 'byebug'

class MinesweeperGame

  attr_reader :board

  def initialize(bombs = 9)
    @bombs = bombs
    @board = Board.new(bombs)
    @board.populate
  end

  def play

    puts "Welcome! There are #{@bombs} bombs to find!"
    # puts ''

    until over?

      board.render
      decision = move_type

      if decision == "reveal"
        pos = guess_pos
        return if explode?(pos)
        board.reveal_recursive(pos)
      else
        pos = flag_position
        board.flag(pos)
      end

    end

    board.render
    puts "You won the game! Congratulations"
    sleep(2)

  end

  def over?

    board.iterative do |_, _, tile|
      next if tile.value == "bomb"
      return false if tile.revealed == false
    end
    true

  end

  def explode?(pos)

    if board[pos].value == "bomb"
      board[pos].reveal
      board.render
      print "You Lose!!"
      sleep(3)
    end

  end

  def move_type
    puts "Would you like to reveal or a flag a position?   "
    gets.chomp
  end

  def guess_pos
    puts "Where would you like to guess? ex. 0,0"
    gets.chomp.split(",").map(&:to_i)
  end

  def flag_position
    puts "Where would you like to flag? ex. 1,1"
    gets.chomp.split(",").map(&:to_i)
  end

end

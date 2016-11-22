### 💣 ⬛️ ◻️ 🚩 ###
require 'colorize'

class Tile

  attr_reader :revealed, :flagged
  attr_accessor :value

  def initialize(value)
    @value = value
    value == "bomb" ? @bombed = true : @bombed = false
    @flagged = false
    @revealed = false
  end

  def reveal
    @revealed = true
  end

  def hide
    @revealed = false
  end

  def flag
    @flagged = true
  end

  def unflag
    @flagged = false
  end


end

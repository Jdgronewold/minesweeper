### 💣 ⬜️ 🚩 ###
require 'Set'


class Board

  attr_reader :board, :hash_pos

  def initialize(num_bombs = 9)
    @board = Array.new(9) { Array.new(9) }
    @num_bombs = num_bombs
    @hash_pos = {}
    @visited = Set.new
  end

  def [](pos)
    row, col = pos
    board[row][col]
  end

  def []=(pos, value)
    row, col = pos
    board[row][col] = value
  end

  def build_arr
    array = ["bomb"] * @num_bombs
    (81 - @num_bombs).times { array << 0 }
    array.shuffle
  end

  def populate
    arr_id = 0
    board_array = build_arr

    iterative do |row, col, _|
      self[[row, col]] = Tile.new(board_array[arr_id])
      hash_pos[[row, col]] = board_array[arr_id]
      arr_id += 1
    end

    count_neighbors

    iterative do |row, col, _|
      self[[row, col]].value = hash_pos[[row, col]]
    end
    nil
  end

  def count_neighbors
    x_change = [-1,-1,-1,0,1,1,1,0]
    y_change = [-1,0,1,1,1,0,-1,-1]


    hash_pos.each do |pos, value|
      next if value == "bomb"
      x, y = pos
      # debugger
      x_change.each_index do |idx|
        x_new = x + x_change[idx]
        y_new = y + y_change[idx]
        next if x_new < 0 || x_new > 8
        next if y_new < 0 || y_new > 8


        pos_new = [x_new, y_new]
        hash_pos[pos] += 1 if self[pos_new].value == "bomb"

      end
    end
    nil

  end

  def render

    row_index = 0
    iterative do |row, _, tile|
      puts '' if row > row_index
      row_index = row
      if tile.revealed
        if tile.flagged
          print '🚩  '
        elsif tile.value == "bomb"
          print '💣  '
        elsif tile.value == 0
          print '⬜️  '
        else
          #colorize here!
          print tile.value.to_s + "  "
        end
      else
        print '⬛️  '
      end
    end
    puts ''
    nil
  end

  def iterative(&prc)
    board.each_index do |row|
      @board[row].each_with_index do |tile, col|
        prc.call(row, col, tile)
      end
    end
  end

  def reveal(pos)
    self[pos].reveal
  end

  def reveal_recursive(pos)
    reveal(pos)
    # debugger
    return if self[pos].value != 0 || @visited.include?(pos)

    @visited << pos

    x_change = [-1, 0, 1, 0]
    y_change = [0, -1, 0, 1]
    x, y = pos

    4.times do |idx|

      next_pos = [x + x_change[idx], y + y_change[idx]]

      next if next_pos[0] < 0 || next_pos[0] > 8
      next if next_pos[1] < 0 || next_pos[1] > 8

      reveal_recursive(next_pos)
    end
    nil
  end

  def flag(pos)
    self[pos].flag
    self[pos].reveal
  end

  def unflag(pos)
    self[pos].unflag
  end

end


if __FILE__ == $PROGRAM_NAME
end

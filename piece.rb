require_relative 'checkers_board'

class Piece

  attr_reader :color, :board
  attr_accessor :type, :jumped, :pos

  def initialize(board, pos, color, type, jumped=false)
    @board = board
    @pos = pos
    @color = color
    @type = type
    @jumped = jumped
  end


  def get_valid_moves(dir)
    valid_arr = []
    x, y = self.pos

    x += dir
    valid_arr << [x, y-1] if x.between?(0, 7) && (y-1).between?(0, 7)
    valid_arr << [x, y+1] if x.between?(0, 7) && (y+1).between?(0, 7)

    valid_arr
  end


  def slide_moves
   self.color == :Y ? dir = 1 : dir = -1
    all_on_board_moves = get_valid_moves(dir)
    places_to_slide = purge_occupied(all_on_board_moves)
  end


  def purge_occupied(board_moves)
    purged_moves = board_moves.select do |location|
      x, y = location
      self.board[x][y].nil?
    end
    purged_moves
  end

  def jump_moves
    self.color == :Y ? dir = 1 : dir = -1
    all_on_board_moves = get_valid_moves(dir)

    places_to_jump = gather_possible_jumps(all_on_board_moves)
  end




  def gather_possible_jumps(dir)
    enemy_locations = gather_my_enemies(all_on_board_moves)
    possible_jump_locations = get_possible_jumps(enemy_locations)
    jump_locations = get_jump_locations(possible_jump_locations)
  end

  def gather_my_enemies(valid_locations)
    enemy_locations = []
    enemy_locations << valid_locations.select do |location|
      x, y = location
      !self.board[x][y].nil? && self.board[x][y].color!=self.color
    end
    enemy_locations
  end

  def get_possible_jumps(enemy_locations)
    possible_jumps = []
    x, y = self.pos
    enemy_locations.each do |location|
      enemy_x, enemy_y = location
      dif_x, dif_y = enemy_x - x, enemy_y - y
      jump_x, jump_y = enemy_x + dif_x, enemy_y + dif_y

      possible_jumps << [jump_x, jump_y] if jump_x.between?(0,7) && jump_y.between?(0,7)
    end
  end


  def get_jump_locations(possible_jump_locations)
    possible_jump_locations.select do |possible_jump|
      x, y = possible_jump
      self.board[x][y].nil?
    end
  end


end





if $PROGRAM_NAME == __FILE__
  load 'piece.rb'
  b = Checkers_Board.new
  b.print_board
  piece = b.board[2][1]
  p piece.get_valid_moves(1)

  #p = Pawn.new(b, [5, 6], :W)
  # board.checked?(:W)
end
















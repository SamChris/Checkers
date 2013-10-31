# encoding: UTF-8
require 'debugger'
require_relative 'checkers_board'
require 'colorize'

class Piece

  attr_reader :color, :board
  attr_accessor :type, :jumped, :pos

  def initialize(board, pos, color, type)
    @board = board
    @pos = pos
    @color = color #:Y or :R
    @type = type #king or pawn
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




  def gather_possible_jumps(all_on_board_moves)
    enemy_locations = gather_my_enemies(all_on_board_moves)
    possible_jump_locations = get_possible_jumps(enemy_locations)
    jump_locations = get_jump_locations(possible_jump_locations)
    jump_locations
  end

  def gather_my_enemies(valid_locations)
    enemy_locations = []
    enemy_locations = valid_locations.select do |location|
      x, y = location
      next if self.board[x][y].nil?
      self.board[x][y].color!=self.color
    end

    enemy_locations
  end

  def get_possible_jumps(enemy_locations)
    possible_jumps = []
    x, y = self.pos
    enemy_locations.each do |location|
      enemyx, enemyy = location
      difx, dify = enemyx - x, enemyy - y
      jumpx, jumpy = enemyx + difx, enemyy + dify

      possible_jumps << [jumpx, jumpy] if jumpx.between?(0,7) && jumpy.between?(0,7)
    end
    possible_jumps
  end


  def get_jump_locations(possible_jump_locations)
    jump_locations = possible_jump_locations.select do |possible_jump|
      x, y = possible_jump
      self.board[x][y].nil?
    end
    jump_locations
  end

  def get_dupped_board
    duplicate_game = Checkers_Board.new
    duplicate_board = duplicate_game.board

    self.board.each_with_index do |el1, i|
      el1.each_with_index do |el2, j|
        original_piece = self.board[i][j]
        if self.board[i][j].nil?
          duplicate_board[i][j] = nil
          next
        end
        duplicate_piece = Piece.new(duplicate_board, original_piece.pos.dup,
                original_piece.color, original_piece.type)
        duplicate_board[i][j] = duplicate_piece
      end
    end
    duplicate_board

  end


  def perform_moves(move_sequence)
    if valid_moves_seq?(move_sequence)
      perform_moves!(move_sequence)
    else
      raise ArgumentError.new("InvalidMoveError")
    end
  end


  def valid_moves_seq?(move_sequence)
    x, y = self.pos
    duplicate_board = get_dupped_board
    duplicate_self = duplicate_board[x][y]

    begin
      # debugger
      duplicate_self.perform_moves!(move_sequence)
    rescue ArgumentError
       return false
    end
      return true

  end



  def perform_moves!(move_sequence)

    move_sequence.each do |move_to|
      possible_slides = slide_moves
      possible_jumps = jump_moves

      unless possible_slides.include?(move_to) || possible_jumps.include?(move_to)
        raise ArgumentError.new("InvalidMoveError")
      end

      if possible_slides.include?(move_to)
        perform_slide(move_to)
      else
        perform_jump(move_to)
      end
    end

  end

  def perform_slide(slide_to)
    x, y = self.pos
    # slides = slide_moves
    # puts "Please slide to one of the following positions:"
#     p slides
    # to_slide = gets.chomp.split(' ').map(&:to_i)
    # unless slides.include?(to_slide)
 #      puts "Invalid Move"
 #      return
 #    end
    newx, newy = slide_to
    #empty the board at the destination and copy the sliding piece there.
    self.board[newx][newy] = nil
    self.board[newx][newy] = self
    #remove the sliding piece from the original location
    self.board[x][y] = nil
    #set the piece's internal position pointer to reflect its new position
    self.pos = [newx, newy]
    print_board
    puts "Press return to continue"
    gets.chomp

  end

  def perform_jump(jump_to)
    x, y = self.pos
     # debugger
    # jumps = jump_moves
    # puts "Please jump to one of the following positions:"
   #  p jumps
   #  to_jump = gets.chomp.split(' ').map(&:to_i)
    # unless jumps.include?(to_jump)
#       puts "Invalid Move"
#       return
#     end
    newx, newy = jump_to
    #empty the board at the destination and copy the jumping piece there.
    self.board[newx][newy] = nil
    self.board[newx][newy] = self
    #remove the jumping piece from the original location
    self.board[x][y] = nil
    #set the piece's internal position pointer to reflect its new position
    self.pos = [newx, newy]
    #remove the piece that was jumped over from the board
    jumpedx, jumpedy = (x + newx)/2, (y + newy)/2
    self.board[jumpedx][jumpedy] = nil
    print_board
    puts "Press enter to continue"
    gets.chomp
  end







  def print_board
    self.board.each_with_index do |el1, i|
        el1.each_with_index do |el2, j|
          piece = self.board[i][j]
       if piece.nil?
         if (i+j) % 2 == 0
            print '   '.colorize(:background => :white)
         else
            print '   '.colorize(:background => :yellow)
         end
       elsif piece.color == :Y
          print ' ⬭ '.colorize(:color => :red, :background => :yellow)
       else
          print ' ⬭ '.colorize(:color => :black, :background => :yellow)
       end
     end
      print "\n"
    end
    print "\n\n\n"

    nil

  end

end



class String
  def black;          "\033[30m#{self}\033[0m" end
  def red;            "\033[31m#{self}\033[0m" end
  def green;          "\033[32m#{self}\033[0m" end
  def  brown;         "\033[33m#{self}\033[0m" end
  def blue;           "\033[34m#{self}\033[0m" end
  def magenta;        "\033[35m#{self}\033[0m" end
  def cyan;           "\033[36m#{self}\033[0m" end
  def gray;           "\033[37m#{self}\033[0m" end
  def bg_black;       "\033[40m#{self}\0330m"  end
  def bg_red;         "\033[41m#{self}\033[0m" end
  def bg_green;       "\033[42m#{self}\033[0m" end
  def bg_brown;       "\033[43m#{self}\033[0m" end
  def bg_blue;        "\033[44m#{self}\033[0m" end
  def bg_magenta;     "\033[45m#{self}\033[0m" end
  def bg_cyan;        "\033[46m#{self}\033[0m" end
  def bg_gray;        "\033[47m#{self}\033[0m" end
  def bold;           "\033[1m#{self}\033[22m" end
  def reverse_color;  "\033[7m#{self}\033[27m" end
end











if $PROGRAM_NAME == __FILE__
  load 'piece.rb'
  b = Checkers_Board.new
  piece0 = b.board[5][2]
  piece0.perform_moves( [ [4, 3] ])
  piece1= b.board[6][1]
  piece1.perform_moves([ [5, 2] ])
  piece3 = b.board[2][1]
  piece3.perform_moves([ [3, 2], [4, 3] ])
  #p = Pawn.new(b, [5, 6], :W)
  # board.checked?(:W)
end
















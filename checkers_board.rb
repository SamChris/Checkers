# encoding: UTF-8
require 'debugger'


class Checkers_Board

  attr_accessor :board

  def initialize
    @board = Array.new(8){Array.new(8)}
      set_up_board
    end

  def set_up_board
    set_up_top
    set_up_bottom
  end

  def set_up_top
    0.upto(2) do |i|
      0.upto(7) do |j|
        next if (i + j) % 2 == 0
        loc = [i, j]
        @board[i][j] = Piece.new(self.board, loc, :Y, :S)
      end
    end
    nil
  end


  def set_up_bottom
    5.upto(7) do |i|
      0.upto(7) do |j|
        next if (i + j) % 2 == 0
        loc = [i, j]
        @board[i][j] = Piece.new(self.board, loc, :R, :S)
      end
    end
    nil
  end


  def print_board
    self.board.each_with_index do |el1, i|
        el1.each_with_index do |el2, j|
          piece = self.board[i][j]
       if piece.nil?
         if (i+j) % 2 == 0
            print '   '.bg_cyan
         else
            print '   '.bg_red
         end
       elsif piece.color == :Y
          print ' Y '.brown.bg_red
       else
          print ' R '.red.bg_gray
       end
     end
      print "\n"
    end
    nil

  end



  def perform_slide(piece, slide_to)
    x, y = piece.pos
    slides = piece.slide_moves
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
    self.board[newx][newy] = piece
    #remove the sliding piece from the original location
    self.board[x][y] = nil
    #set the piece's internal position pointer to reflect its new position
    piece.pos = [newx, newy]
    print_board

  end


  def perform_jump(piece, jump_to)
    x, y = piece.pos
    # debugger
    jumps = piece.jump_moves
    # puts "Please jump to one of the following positions:"
   #  p jumps
   #  to_jump = gets.chomp.split(' ').map(&:to_i)
    # unless jumps.include?(to_jump)
#       puts "Invalid Move"
#       return
#     end
    newx, newy = jump_tp
    #empty the board at the destination and copy the jumping piece there.
    self.board[newx][newy] = nil
    self.board[newx][newy] = piece
    #remove the jumping piece from the original location
    self.board[x][y] = nil
    #set the piece's internal position pointer to reflect its new position
    piece.pos = [newx, newy]
    #remove the piece that was jumped over from the board
    jumpedx, jumpedy = (x + newx)/2, (y + newy)/2
    self.board[jumpedx][jumpedy] = nil
    print_board
    puts "Press any key to continue"
    gets.chomp
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



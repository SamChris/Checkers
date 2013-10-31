# encoding: UTF-8
require "./piece"


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
        @board[i][j] = Piece.new(loc, :Y, :S)
      end
    end
    nil
  end


  def set_up_bottom
    5.upto(7) do |i|
      0.upto(7) do |j|
        next if (i + j) % 2 == 0
        loc = [i, j]
        @board[i][j] = Piece.new(loc, :R, :S)
      end
    end
    nil
  end


  def print_board
    0.upto(7) do |i|
      0.upto(7) do |j|
        if @board[i][j]
          print 'P '
        else
          print 'X '
        end
      end
      print "\n"
    end
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



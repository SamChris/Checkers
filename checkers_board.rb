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







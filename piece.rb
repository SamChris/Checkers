class Piece

  attr_reader :color
  attr_accessor :location, :type

  def initialize(location, color, type)
    @location = location
    @color = color
    @type = type
  end



end

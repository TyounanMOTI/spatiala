class Listener
  attr_accessor :position, :direction, :children

  def initialize(position, direction)
    @position = position
    @direction = direction.normalize
    @children = Array.new
  end
end

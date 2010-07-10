class Listener
  attr_accessor :position, :direction

  def initialize(position, direction)
    @position = position
    @direction = direction.normalize
  end
end

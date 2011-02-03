class Listener
  attr_accessor :position, :direction, :children

  def initialize(position, direction)
    @position = position
    @direction = direction.normalize
    @children = Array.new
  end

  def normalize(normalizer)
    return Listener.new(@position.transform(normalizer), @direction.transform(normalizer))
  end
end

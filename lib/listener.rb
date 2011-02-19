class Listener
  attr_accessor :position, :direction

  def initialize(position, direction)
    @position = position
    @direction = direction.normalize
  end

  def normalize(normalizer)
    return Listener.new(@position.transform(normalizer), @direction.transform(normalizer))
  end
  alias :transform :normalize

  def dualize
    @position.dualize
  end
end

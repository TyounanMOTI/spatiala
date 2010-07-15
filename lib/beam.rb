class Beam
  attr_reader :origin
  attr_accessor :children, :deltas

  def initialize(origin, *deltas)
    @origin = origin
    @deltas = deltas
    @children = Array.new
  end
end

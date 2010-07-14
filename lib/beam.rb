class Beam
  attr_reader :origin, :deltas
  attr_accessor :children

  def initialize(origin, *deltas)
    @origin = origin
    @deltas = deltas
    @children = Array.new
  end
end

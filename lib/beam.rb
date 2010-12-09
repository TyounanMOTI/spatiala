class Beam < Polygon
  attr_reader :origin
  attr_accessor :children, :deltas, :reference_segment

  def initialize(origin, *deltas)
    @origin = origin
    @deltas = deltas.flatten
    @children = Array.new
    super @deltas
  end
end

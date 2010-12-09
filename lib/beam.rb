class Beam < Polygon
  attr_reader :origin
  attr_accessor :children, :reference_segment

  def initialize(origin, vertices)
    @origin = origin
    @children = Array.new
    super vertices
  end
end

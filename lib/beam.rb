class Beam < Polygon
  attr_accessor :children, :reference_segment

  def initialize(vertices)
    @children = Array.new
    super vertices
  end
end

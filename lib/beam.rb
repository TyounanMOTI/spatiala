class Beam < Polygon
  attr_accessor :children

  def initialize(vertices)
    @children = Array.new
    super vertices
  end

  def transform(matrix)
    Beam.new(super.vertices)
  end
end

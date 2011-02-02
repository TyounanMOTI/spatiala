class Beam < Polygon
  attr_accessor :children

  def initialize(vertices)
    @children = Array.new
    super vertices
  end

  def transform(matrix)
    Beam.new(super.vertices)
  end

  def illumination_ray
    lines[1]
  end
end

class Beams < Array
  def initialize(beams=0)
    super
  end

  def transform(matrix)
    Beams.new(self.map { |i| i.transform(matrix) })
  end
end

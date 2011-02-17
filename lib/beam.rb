class Beam < Polygon
  attr_reader :listener, :target_ray
  attr_accessor :children

  def initialize(vertices, listener=nil, target_ray=nil)
    @children = Array.new
    @listener = listener
    @target_ray = target_ray
    super vertices
  end

  def transform(matrix)
    Beam.new(super.vertices)
  end

  def illuminator
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

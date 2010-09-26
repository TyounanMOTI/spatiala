class VisibilityMap
  def initialize(tracer)
    @regions = tracer.geometry.lines.map do |i|
      [
       Ray.new(i.origin, i.destination).dualize,
       Ray.new(i.destination, i.origin).dualize
      ]
    end
    @regions.flatten!.compact!
  end

  def get_intersection_points
    return IntersectionPoints.new(Vector.new(0,0))
  end

  attr_reader :regions
end

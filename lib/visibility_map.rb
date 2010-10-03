class VisibilityMap
  attr_reader :regions

  def initialize(tracer)
    @regions = tracer.geometry.lines.map do |i|
      [
       Ray.new(i.origin, i.destination).dualize,
       Ray.new(i.destination, i.origin).dualize
      ]
    end
    @regions.flatten!
    @regions.compact!
    @tracer = tracer
  end

  def get_intersection_points
    vision = @tracer.listener.position.dualize
    intersections = @regions.map do |region|
      region.rays.map { |ray| vision.intersect ray }
    end
    intersections.flatten!
    intersections.reject! { |i| i <= 0 }
    intersections.uniq!
    intersections.sort!
    intersections.reject! { |i| occluded?(i) }
    return IntersectionPoints.new(intersections)
  end

  def occluded?(intersection)
    return false
  end

  class IntersectionPoints < Array
    def initialize(*args)
      super
    end
  end
end

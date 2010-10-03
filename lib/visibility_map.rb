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
    intersection_points = @regions.map do |region|
      region.rays.map { |ray| IntersectionPoint.new((vision*vision.intersect(ray)).destination, region) }
    end
    intersection_points = IntersectionPoints.new(intersections)
    intersection_points.flatten!
    intersection_points.sort_by { |i| i.point.x }
    intersection_points.reject! { |i| occluded?(i) }
    return intersection_points
  end

  def occluded?(intersection)
    return false
  end

  class IntersectionPoints < Array
    def initialize(*args)
      super
    end
  end

  class IntersectionPoint
    attr_reader :point, :region

    def initialize(point, region)
      @point = point
      @region = region
    end
  end
end

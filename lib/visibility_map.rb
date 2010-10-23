class VisibilityMap
  attr_reader :regions

  def initialize(tracer)
    @regions = tracer.geometry.lines.map { |i| [i.dualize, i.reverse.dualize] }.flatten.compact
    @tracer = tracer
  end

  def get_intersection_points
    intersections = get_intersections

    intersection_points = IntersectionPoints.new(intersections)
    rejected = reject_occluded_points(intersection_points)
    rejected.sort_by { |i| i.point.x }
    return intersection_points
  end

  def get_intersections
    vision = @tracer.listener.position.dualize
    @regions.map do |region|
      region.rays.map do |ray|
        ratio = vision.intersect(ray)
        next if ratio.nil?
        IntersectionPoint.new((vision*ratio).destination, region, @tracer.listener)
      end
    end.flatten.compact
  end

  def reject_occluded_points(intersection_points)
    intersection_points.delete_if { |i| @tracer.geometry.without_window.occluded?(i.dualize) }
  end

  class IntersectionPoints < Array
    def initialize(*args)
      super
    end
  end

  class IntersectionPoint
    attr_reader :point, :region, :listener

    def initialize(point, region, listener)
      @point = point
      @region = region
      @listener = listener
    end

    def dualize
      Ray.new(@listener.position, Vector.new(0, point.y)).fit(@region.original)
    end
  end
end

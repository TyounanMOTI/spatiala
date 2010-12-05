class VisibilityMap
  attr_reader :regions

  def initialize(tracer)
    @regions = tracer.geometry.lines.map do |i|
      # also dualize reversed ray, because non facing line will be nil when dualized
      [i.dualize, i.reverse.dualize]
    end.flatten.compact
    @tracer = tracer
  end

  def get_intersection_points
    intersections = get_intersections
    rejected = reject_occluded_points(intersections)
    return IntersectionPoints.new(rejected.sort_by { |i| i.point.x })
  end

  def get_intersections
    vision = @tracer.listener.position.dualize
    @regions.map do |region|
      region.rays.map do |ray|
        ratio = vision.intersect(ray)
        next if ratio.nil?
        IntersectionPoint.new(ratio, region, @tracer.listener)
      end
    end.flatten.compact
  end

  def reject_occluded_points(intersection_points)
    intersection_points.delete_if { |i| @tracer.geometry.without_window.occluded?(i.dualize) }
  end

  class IntersectionPoints < Array
    def initialize(args)
      super
    end
  end

  class IntersectionPoint < Vector
    attr_reader :ratio, :region, :listener

    def initialize(ratio, region, listener)
      @ratio = ratio
      @region = region
      @listener = listener
      super self.point.elements
    end

    def point
      (@listener.position.dualize * @ratio).destination
    end

    def dualize
      Ray.new(@listener.position, Vector.new(0, point.y)).fit(@region.original)
    end
  end
end

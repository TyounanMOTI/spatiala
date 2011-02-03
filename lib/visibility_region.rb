class VisibilityRegion < Polygon
  attr_reader :original
  alias :rays :lines

  IntersectionPoints = VisibilityMap::IntersectionPoints
  IntersectionPoint = VisibilityMap::IntersectionPoint

  def initialize(original, vertices)
    @original = original
    super vertices
  end

  def ==(other)
    return (@original == other.original) && (rays == other.rays)
  end

  def intersect(listener)
    view_ray = listener.dualize
    points = rays.map do |line|
      ratio = view_ray.intersect(line)
      next if ratio.nil?
      IntersectionPoint.new(ratio, listener.position, @original)
    end.compact
    return IntersectionPoints.new(points)
  end
end

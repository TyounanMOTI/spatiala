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

  def intersect(view_ray)
    rays.map do |i|
      ratio = view_ray.intersect(i)
      next if ratio.nil?
      {:ratio => ratio, :original => @original}
    end.compact
  end
end

class VisibilityRegions < Array
  def initialize(arg)
    super
  end
end

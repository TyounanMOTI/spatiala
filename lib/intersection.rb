class Intersection
  attr_reader :origin, :target_ray, :ratios

  def initialize(origin, target_ray, ratios)
    @origin = origin
    @target_ray = target_ray
    @ratios = ratios
  end

  def to_rays
    @ratios.map { |i| Ray.new(@origin, (target_ray*i).destination) }
  end
end


class Intersections
  include Enumerable

  attr_reader :intersections

  def initialize(intersections)
    @intersections = intersections
  end

  def each
    @intersections.each { |i| yield i }
  end

  def to_rays
    self.map { |i| i.to_rays }.flatten
  end

  def length
    @intersections.length
  end
end

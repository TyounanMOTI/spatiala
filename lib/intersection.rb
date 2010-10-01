class Intersection
  attr_reader :listener, :target_ray, :ratios

  def initialize(listener, target_ray, ratios)
    @listener = listener
    @target_ray = target_ray
    @ratios = ratios
  end

  def to_rays
    @ratios.map { |i| Ray.new(@listener.position, (target_ray*i).destination) }
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

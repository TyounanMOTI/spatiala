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

  def merge(intersections)
    result = Intersections.new(@intersections.dup)
    intersections.each do |intersection|
      index = @intersections.index { |i| i.target_ray == intersection.target_ray }
      if index.nil?
        result.intersections << intersection
      else
        result.intersections[index].ratios.concat(intersection.ratios)
      end
    end
    return result
  end
end

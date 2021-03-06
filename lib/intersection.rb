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

  def dup
    self.class.new(@origin.dup, @target_ray.dup, @ratios.dup)
  end

  def sort
    self.class.new(@origin.dup, @target_ray.dup, @ratios.sort)
  end

  def to_cracks
    cracks = []
    @ratios.each_index do |i|
      current_ratio, next_ratio = @ratios[i..i+1]
      break if next_ratio.nil?
      line = @target_ray*i
      cracks << Crack.new(line, self.to_rays[i..i+1])
    end
    return cracks
  end
end


class Intersections < Array
  def initialize(*args)
    super
  end

  def to_rays
    self.map { |i| i.to_rays }.flatten
  end

  def merge(other)
    result = Intersections.new(self.dup)
    other.each do |i|
      target_index = self.index { |j| j.target_ray == i.target_ray }
      if target_index.nil?
        result << i
      else
        result[target_index].ratios.concat(i.ratios)
      end
    end
    return result
  end

  def dup
    self.class.new(map { |i| i.dup })
  end

  def sort
    self.class.new(map { |i| i.sort })
  end

  def to_cracks
    map { |i| i.to_cracks }.flatten
  end
end

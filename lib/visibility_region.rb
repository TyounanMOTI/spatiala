class VisibilityRegion
  attr_reader :rays, :original

  def initialize(original, *rays)
    @original = original
    @rays = rays.flatten
  end

  def vertices
    return @rays.map { |ray| [ray.origin, ray.destination] }.flatten.uniq
  end
end

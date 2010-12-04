class VisibilityRegion
  attr_reader :rays, :original

  def initialize(original, *rays)
    @original = original
    @rays = rays.flatten
  end

  def vertices
    return @rays.map { |ray| [ray.origin, ray.destination] }.flatten.uniq
  end

  def ==(other)
    return (@original == other.original) && (@rays == other.rays)
  end
end

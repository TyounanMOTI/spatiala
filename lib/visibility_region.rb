class VisibilityRegion
  attr_reader :rays, :original

  def initialize(original, *rays)
    @original = original
    @rays = rays.flatten
  end

  def vertices
    @rays.map { |ray| [ray.origin, ray.destination] }.flatten
  end
end

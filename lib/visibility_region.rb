class VisibilityRegion < Polygon
  attr_reader :original
  alias :rays :lines

  def initialize(original, *rays)
    @original = original
    vertices = rays.flatten.collect { |ray| ray.origin }
    super vertices
  end

  def ==(other)
    return (@original == other.original) && (rays == other.rays)
  end
end

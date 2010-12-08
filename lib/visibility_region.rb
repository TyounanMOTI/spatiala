class VisibilityRegion < Polygon
  attr_reader :original
  alias :rays :lines

  def initialize(original, vertices)
    @original = original
    super vertices
  end

  def ==(other)
    return (@original == other.original) && (rays == other.rays)
  end
end

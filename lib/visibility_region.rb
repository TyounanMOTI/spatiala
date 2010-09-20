class VisibilityRegion
  attr_reader :rays, :original

  def initialize(original, *rays)
    @original = original
    @rays = rays.flatten
  end
end

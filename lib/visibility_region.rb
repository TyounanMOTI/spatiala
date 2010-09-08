class VisibilityRegion
  attr_reader :rays

  def initialize(*rays)
    @rays = rays.flatten
  end
end

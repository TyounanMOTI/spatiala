class VisibilityRegion
  attr_reader :rays

  def initialize(ray)
    @rays = [ray]
  end
end

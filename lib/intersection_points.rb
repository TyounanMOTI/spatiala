class IntersectionPoints
  def initialize(*points)
    @points = points.flatten
  end

  def length
    @points.length
  end
end

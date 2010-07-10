class Ray
  attr_accessor :origin, :delta

  def initialize(origin=Vector.new(0,0), destination=Vector.new(0,0))
    @origin = origin
    @delta = destination - origin
  end
end

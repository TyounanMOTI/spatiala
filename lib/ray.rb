require 'vector'

class Ray
  attr_accessor :origin, :destination, :delta

  def initialize(origin=Vector.new(0,0), destination=Vector.new(0,0))
    @origin = origin
    @destination = destination
    @delta = destination - origin
  end
end

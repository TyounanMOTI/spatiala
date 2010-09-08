require 'vector'

class Ray
  attr_accessor :origin, :destination, :delta

  def initialize(origin=Vector.new(0,0), destination=Vector.new(0,0))
    @origin = origin
    @destination = destination
    @delta = destination - origin
  end

  def origin=(origin)
    @origin = origin
    @delta = @destination - @origin
  end

  def destination=(destination)
    @destination = destination
    @delta = @destination - @origin
  end

  def delta=(delta)
    @delta = delta
    @destination = @origin + @delta
  end

  def intersect(target)
    cross = @delta.cross(target.delta)
    return -1 if (cross.length == 0)
    return (((target.origin - @origin).cross(target.delta))*cross).to_f / ((cross*cross)).to_f
  end

  def intersect?(wall)
    ray_to_wall = self.intersect(wall)
    wall_to_ray = wall.intersect(self)
    # return false if intersect with both end of wall
    if ((ray_to_wall > 0 && ray_to_wall < 1) &&
        (wall_to_ray > 0 && wall_to_ray < 1)) then
      return true
    end
    return false
  end

  def ==(ray)
    return true if @origin == ray.origin && @destination == ray.destination
    return false
  end

  def transform(matrix)
    Ray.new(@origin.transform(matrix), @destination.transform(matrix))
  end

  def dualize
    return VisibilityRegion.new(self)
  end
end

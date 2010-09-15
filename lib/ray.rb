require 'vector'

class Ray
  attr_accessor :origin, :destination, :delta
  INFINITE = 1.0/0.0

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
    if Ray.new(Vector.new(0,1), Vector.new(0,-1)).facing(self) == :false
      return nil
    end

    if @origin.x <= 0 && @destination.x <= 0
      return nil
    end

    if @destination.x <= 0
      rays = [@origin.dualize]
      rays.push Ray.new(rays[0].origin, Vector.new(INFINITE, 1))
      rays.push Ray.new(rays[0].destination, Vector.new(INFINITE, -1))
      return VisibilityRegion.new(rays)
    end

    if @origin.x <= 0
      rays = [@destination.dualize]
      rays.push Ray.new(rays[0].origin, Vector.new(-INFINITE, 1))
      rays.push Ray.new(rays[0].destination, Vector.new(-INFINITE, -1))
      return VisibilityRegion.new(rays)
    end

    rays = [@origin.dualize, @destination.dualize]
    rays.push Ray.new(rays[0].origin, rays[1].origin)
    rays.push Ray.new(rays[0].destination, rays[1].destination)
    return VisibilityRegion.new(rays)
  end

  def normal
    @delta.transform(Matrix.rotator(Math::PI/2))
  end

  def facing(ray)
    if (ray.origin - @origin)*ray.normal < 0
      if (ray.origin - @destination)*ray.normal < 0
        return :true
      end
      return :upper
    else
      if (ray.origin - @destination)*ray.normal < 0
        return :lower
      end
      return :false
    end
  end
end

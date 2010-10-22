require 'vector'

class Ray
  attr_accessor :origin, :destination, :delta

  BIG = 1.0e5

  def initialize(origin=Vector.new(0,0), destination=Vector.new(0,0))
    @origin = origin
    @destination = destination
    @delta = destination - origin
  end

  WINDOW = Ray.new(Vector.new(0,1), Vector.new(0,-1))

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
    return nil unless intersect?(target)
    return intersect_as_directional_line(target)
  end

  def intersect_as_directional_line(target)
    cross = @delta.cross(target.delta)
    return -1 if (cross.length == 0)
    return (((target.origin - @origin).cross(target.delta))*cross).to_f / ((cross*cross)).to_f
  end

  def intersect?(wall)
    ray_to_wall = self.intersect_as_directional_line(wall)
    wall_to_ray = wall.intersect_as_directional_line(self)
    # return false if intersect with both end of wall
    if ((ray_to_wall >= 0 && ray_to_wall <= 1) &&
        (wall_to_ray >= 0 && wall_to_ray <= 1)) then
      return true
    end
    return false
  end

  def ==(ray)
    return true if !ray.nil? && @origin == ray.origin && @destination == ray.destination
    return false
  end

  def transform(matrix)
    Ray.new(@origin.transform(matrix), @destination.transform(matrix))
  end

  def dualize
    if facing == :false
      return nil
    end

    if @origin.x <= 0 && @destination.x <= 0
      return nil
    end

    if @destination.x <= 0
      rays = [
              Ray.new(Vector.new(BIG, -1), @origin.dualize.destination),
              @origin.dualize.reverse,
              Ray.new(@origin.dualize.origin, Vector.new(BIG, 1))
             ]
      return VisibilityRegion.new(self, rays)
    end

    if @origin.x <= 0
      rays = [
              Ray.new(Vector.new(-BIG, 1), @destination.dualize.origin),
              @destination.dualize,
              Ray.new(@destination.dualize.destination, Vector.new(-BIG, -1))
             ]
      return VisibilityRegion.new(self, rays)
    end

    if facing == :upper
      intersection_ratio = @origin.dualize.intersect(@destination.dualize)
      intersection_point = @origin.dualize.origin + @origin.dualize.delta * intersection_ratio

      vertices = [
                  @origin.dualize.origin,
                  @destination.dualize.origin,
                  intersection_point
                 ].sort_by { |i| i.x }

      rays = Polygon.new(vertices).lines
      return VisibilityRegion.new(self, rays)
    end

    if facing == :lower
      intersection_ratio = @origin.dualize.intersect(@destination.dualize)
      intersection_point = @origin.dualize.origin + @origin.dualize.delta * intersection_ratio

      vertices = [
                  @origin.dualize.destination,
                  @destination.dualize.destination,
                  intersection_point
                 ].sort_by { |i| i.x }

      rays = Polygon.new(vertices).lines
      return VisibilityRegion.new(self, rays)
    end

    vertices = [
                @origin.dualize.origin,
                @origin.dualize.destination,
                @destination.dualize.destination,
                @destination.dualize.origin
               ]
    rays = Polygon.new(vertices).lines
    return VisibilityRegion.new(self, rays)
  end

  def normal
    @delta.transform(Matrix.rotator(Math::PI/2))
  end

  def facing
    if @origin == WINDOW.destination
      if @destination.x > 0
        return :true
      else
        return :false
      end
    end

    if @destination == WINDOW.origin
      if @origin.x > 0
        return :true
      else
        return :false
      end
    end

    return :false if @origin == WINDOW.origin
    return :false if @destination == WINDOW.destination

    if (@origin - WINDOW.origin)*normal <= 0
      if (@origin - WINDOW.destination)*normal <= 0
        return :true
      end
      return :upper
    else
      if (@origin - WINDOW.destination)*normal <= 0
        return :lower
      end
      return :false
    end
  end

  def reverse
    Ray.new(@destination, @origin)
  end

  def maximize
    Ray.new(@origin, @origin + @delta.normalize * BIG)
  end

  def *(arg)
    case arg
    when Ray
      self.delta * arg.delta
    else
      Ray.new(@origin, @origin + @delta*arg)
    end
  end

  def include_edge?(point)
    return true if point == @origin || point == @destination
    return false
  end

  def length
    @delta.length
  end

  def fit(ray)
    ratio = self.intersect_as_directional_line(ray)
    return self if ratio < 0
    return self*ratio
  end

  def look_front
    return self if @origin.x < @destination.x
    return self.reverse
  end
end

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
    if ((ray_to_wall >= -0.1e-10 && ray_to_wall <= 1.0 + 0.1e-10) &&
        (wall_to_ray >= -0.1e-10 && wall_to_ray <= 1.0 + 0.1e-10)) then
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

  def normalizer
    center = (@origin + @destination)/2
    translator = Matrix::Translator[-center.x, -center.y, -center.z]
    translated_window = self.transform(translator)
    theta = Math.atan(translated_window.origin.y.to_f / translated_window.origin.x.to_f)
    rotator = Matrix::Rotator[Math::PI/2 - theta]
    rotated_window = translated_window.transform(rotator)
    scaler = Matrix::Scaler[1,1/rotated_window.origin.y.abs]
    window = rotated_window.transform(scaler)

    transformer = translator * rotator * scaler

    unless window == WINDOW
      transformer = transformer * Matrix::Reflector[0,1,0] * Matrix::Reflector[1,0,0]
    end

    return transformer
  end

  def dualize
    case @origin
    when VisibilityMap::IntersectionPoint
      dualize_to_beam
    when Vector
      dualize_to_region
    end
  end

  def dualize_to_beam
    vertices = [
                @origin.dualize.origin,
                @origin.dualize.destination,
                @destination.dualize.destination,
                @destination.dualize.origin,
               ]

    beam = Beam.new(vertices, @origin.listener, @origin.target_ray)
    return beam
  end

  def dualize_to_region
    if facing == :false
      return nil
    end

    if @origin.x <= 0 && @destination.x <= 0
      return nil
    elsif @destination.x <= 0
      vertices = [
              Vector.new(BIG, -1),
              @origin.dualize.destination,
              @origin.dualize.origin,
              Vector.new(BIG, 1)
             ]

    elsif @origin.x <= 0
      vertices = [
              Vector.new(-BIG, 1),
              @destination.dualize.origin,
              @destination.dualize.destination,
              Vector.new(-BIG, -1)
             ]
    elsif facing == :upper
      intersection_ratio = @origin.dualize.intersect(@destination.dualize)
      intersection_point = @origin.dualize.origin + @origin.dualize.delta * intersection_ratio

      vertices = [
                  @origin.dualize.origin,
                  @destination.dualize.origin,
                  intersection_point
                 ].sort_by { |i| i.x }
    elsif facing == :lower
      intersection_ratio = @origin.dualize.intersect(@destination.dualize)
      intersection_point = @origin.dualize.origin + @origin.dualize.delta * intersection_ratio

      vertices = [
                  @origin.dualize.destination,
                  @destination.dualize.destination,
                  intersection_point
                 ].sort_by { |i| i.x }
    else
      vertices = [
                  @origin.dualize.origin,
                  @origin.dualize.destination,
                  @destination.dualize.destination,
                  @destination.dualize.origin
                 ]
    end

    return VisibilityRegion.new(self, vertices)
  end

  def normal
    @delta.transform(Matrix::Rotator[Math::PI/2])
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

  def trim(range)
    Ray.new((self*range.first).destination, (self*range.last).destination)
  end

  def ratio(point)
    (point - @origin).length / @delta.length
  end

  def range(target)
    Range.new(target.ratio(@origin), target.ratio(@destination))
  end

  def include?(point)
    target = Ray.new(@origin, point)
    return true if (point - @origin).length < 1.0e-10
    return true if (self*target - self.length*target.length).abs < 1.0e-10 && target.length - self.length < 1.0e-10
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

  def hash
    [@origin, @destination].join.hash
  end
end

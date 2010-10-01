class CrackList
  include Enumerable
  attr_reader :cracks

  def initialize(*args)
    case args.flatten[0]
    when Crack
      @cracks = args.flatten
    when Geometry
      @geometry = args.shift
      @listener = args.shift
      @cracks = initialize_from_geometry_and_listener
    else
      @cracks = Array.new
    end
  end

  def initialize_from_geometry_and_listener
    return Array.new
  end

  def connect_listener_and_vertices
    Intersections.new(@geometry.lines.map { |i| Intersection.new(@listener, i, [0.0, 1.0]) })
  end

  def reject_occluded(intersections)
    result = intersections.map do |intersection|
      rays = intersection.to_rays
      result_ratio = intersection.ratios.dup.delete_if do |i|
        @geometry.occluded?(rays[intersection.ratios.index(i)])
      end
      next if result_ratio.empty?
      Intersection.new(@listener, intersection.target_ray, result_ratio)
    end.compact

    return Intersections.new(result)
  end

  def expand(rays)
    additional_rays = Array.new
    rays.each do |ray|
      second_intersection = @geometry.intersect(ray.maximize).fetch(1,nil)
      next if second_intersection.nil?
      second_intersection_point = ray.origin + ray.maximize.delta*second_intersection[:ratio]
      next if second_intersection_point == ray.destination
      additional_rays << Ray.new(ray.origin, second_intersection_point)
    end
    return rays.dup.concat(additional_rays)
  end

  def append(crack)
    i = @cracks.index { |j| j.line == crack.line }
    unless i then
      @cracks.push crack
    else
      @cracks[i].rays.push crack.rays
      @cracks[i].rays.flatten!
    end
  end

  def [](i)
    return @cracks[i]
  end

  def length
    return @cracks.length
  end

  def each
    @cracks.each do |crack|
      yield crack
    end
  end

  def to_beams
    list = Array.new
    self.each { |i| list << i.to_beam }
    return list
  end
end

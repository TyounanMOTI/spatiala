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
    intersections = expand(reject_occluded(connect_listener_and_vertices))
    return intersections.sort.to_cracks
  end

  def connect_listener_and_vertices
    Intersections.new(@geometry.lines.map { |i| Intersection.new(@listener.position, i, [0.0, 1.0]) })
  end

  def reject_occluded(intersections)
    result = intersections.map do |intersection|
      rays = intersection.to_rays
      result_ratio = intersection.ratios.dup.delete_if do |i|
        @geometry.occluded?(rays[intersection.ratios.index(i)])
      end
      next if result_ratio.empty?
      Intersection.new(@listener.position, intersection.target_ray, result_ratio)
    end.compact

    return Intersections.new(result)
  end

  def expand(intersections)
    additional_intersection = Array.new
    intersections.to_rays.each do |ray|
      second_intersection = @geometry.intersect(ray.maximize).fetch(1,nil)
      next if second_intersection.nil?
      ratio = second_intersection.target_ray.intersect(ray.maximize)
      next if ratio.nil? || ratio < 0.0001 || ratio > 0.999
      additional_intersection << Intersection.new(@listener.position, second_intersection.target_ray, [ratio])
    end
    return intersections.merge(Intersections.new(additional_intersection))
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
    map { |i| i.to_beam }
  end
end

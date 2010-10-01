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
    @geometry.lines.map { |i| {:line => i, :ratios => [0.0, 1.0]} }
  end

  def reject_occluded_rays(ratios)
    ratios.map do |ratio|
      rays = ratio_to_rays(ratio)
      result_ratio = ratio[:ratios].dup.delete_if do |i|
        @geometry.occluded?(rays[ratio[:ratios].index(i)])
      end
      next if result_ratio.empty?
      {:line => ratio[:line], :ratios => result_ratio}
    end.compact
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

  def ratios_to_rays(ratios)
    ratios.map { |i| ratio_to_rays(i) }.flatten
  end

  def ratio_to_rays(ratio)
    ratio[:ratios].map do |i|
      destination = (ratio[:line]*i).destination
      Ray.new(@listener.position, destination)
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

  class Intersection
    attr_reader :target_ray, :ratios

    def initialize(target_ray, ratios)
      @target_ray = target_ray
      @ratios = ratios
    end

    def to_ray(listener)
      @ratios.map { |i| Ray.new(listener.position, (target_ray*i).destination) }
    end
  end

  class Intersections
    include Enumerable

    attr_reader :intersections

    def initialize(intersections)
      @intersections = intersections
    end

    def each
      @intersections.each { |i| yield i }
    end
  end
end

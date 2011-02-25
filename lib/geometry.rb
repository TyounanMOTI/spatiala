require 'polygon'

class Geometry
  attr_reader :polygons

  def initialize(*polygons)
    @polygons = polygons.flatten
  end

  def generate_beam_tree(listener)
    pencil_shape_split(listener).traverse
  end

  def pencil_shape_split(listener)
    BeamTree.new(listener, extend_rays(reject_occluded_rays(connect_listener_vertices(listener))).to_beams)
  end

  def connect_listener_vertices(listener)
    rays = IntersectionRays.new
    lines.each { |i| rays.append(i, [Ray.new(listener.position, i.origin), Ray.new(listener.position, i.destination)]) }
    rays
  end

  def reject_occluded_rays(rays)
    rays.reject { |ray| occlude?(ray) }
  end

  def extend_rays(rays)
    rays.each_ray do |ray|
      next if extend_ray(ray).nil?
      rays.append(extend_ray(ray)[:target_ray], extend_ray(ray)[:ray])
    end
    return rays
  end

  def extend_ray(ray)
    intersect(ray.to_infinite_ray)[1]
  end

  def vertices
    @polygons.map { |i| i.vertices }.flatten
  end

  def lines
    @polygons.map { |i| i.lines }.flatten
  end

  def ends_of_lines
    lines.map do |line|
      [line.origin, line.destination].map { |vertex| {:vertex => vertex, :line => line} }
    end.flatten
  end

  def lines_include(point)
    lines.select { |i| i.include?(point) }
  end

  def nearest_intersect_line_with(ray)
    return nil if intersect(ray).empty?
    return intersect(ray).first.target_ray
  end

  def occlude?(ray)
    return false if ray.length == 0
    return (not lines_include(ray.destination).include?(nearest_intersect_line_with(ray)))
  end

  def intersect(ray)
    intersections = lines.map { |line| [Intersection.new(ray.origin, line, [line.intersect(ray)]), ray.intersect(line)] }.delete_if { |i| i[1].nil? }.sort_by { |i| i[1] }
    return Intersections.new(intersections.collect { |i| i[0] })
  end

  def normalize(window)
    return transform(window.normalizer)
  end

  def transform(matrix)
    polygons = @polygons.map { |i| i.transform(matrix) }
    return Geometry.new(polygons)
  end

  def without_window
    Geometry.new(@polygons.map { |i| i.disable(Ray::WINDOW) })
  end

  def to_regions
    # also dualize reversed ray, because non facing line will be nil when dualized
    VisibilityRegions.new(lines.map { |i| [i.dualize, i.reverse.dualize] }.flatten.compact)
  end

  class IntersectionRays < Hash
    def initialize
      super []
    end

    def length
      inject(0) { |count, i| count + i.last.length }
    end

    def append(target_ray, rays)
      self[target_ray] = self[target_ray] + [rays].flatten
      self
    end

    def reject
      each do |key, value|
        self[key] = value.reject { |i| yield(i) }
      end
    end

    def to_a
      values.flatten
    end

    def each_ray
      to_a.each { |i| yield i }
    end
  end
end

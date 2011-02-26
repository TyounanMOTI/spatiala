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

  def stretch_ray(ray)
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
    return intersect(ray).first.keys.first
  end

  def occlude?(ray)
    lines.any? { |line| ray.intersect?(line) && ray.intersect(line) < 1.0-1.0e-10 }
  end

  def intersect(ray)
    lines.map do |line|
      {line => ray.fit(line), :ratio => ray.intersect(line) }
    end.reject { |i| i[:ratio].nil? }.sort_by { |i| i[:ratio] }.each { |i| i.delete(:ratio) }
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

    def reject_occluded_by(geometry)
      reject { |ray| geometry.occlude?(ray) }
    end

    def stretch(geometry)
      each_ray do |ray|
        append(*geometry.stretch_ray(ray).shift)
      end
      self
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

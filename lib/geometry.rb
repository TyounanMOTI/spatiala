require 'polygon'

class Geometry
  attr_reader :polygons

  def initialize(*polygons)
    @polygons = polygons.flatten
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
    lines.select { |i| i.include_edge?(point) }
  end

  def nearest_intersect_line_with(ray)
    return nil if intersect(ray).empty?
    return intersect(ray).first.target_ray
  end

  def occluded?(ray)
    return false if ray.length == 0
    return (not lines_include(ray.destination).include?(nearest_intersect_line_with(ray)))
  end

  def intersect(ray)
    intersections = lines.map { |line| [Intersection.new(ray.origin, line, [line.intersect(ray)]), ray.intersect(line)] }.delete_if { |i| i[1].nil? }.sort_by { |i| i[1] }
    return Intersections.new(intersections.collect { |i| i[0] })
  end

  def normalize(normalizer)
    polygons = @polygons.map { |i| i.transform(normalizer) }
    return Geometry.new(polygons)
  end

  def without_window
    Geometry.new(@polygons.map { |i| i.disable(Ray::WINDOW) })
  end
end

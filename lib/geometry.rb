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

  def lines_include_vertex(vertex)
    lines.map { |i| i if i.origin == vertex || i.destination == vertex }.compact
  end

  def nearest_intersect_line_with(ray)
    intersect(ray).intersections.first.target_ray
  end

  def occluded?(ray)
    not lines_include_vertex(ray.destination).include?(nearest_intersect_line_with(ray))
  end

  def intersect(ray)
    intersections = lines.map { |line| [Intersection.new(ray.origin, line, [line.intersect(ray)]), ray.intersect(line)] }.delete_if { |i| i[1].nil? }.sort_by { |i| i[1] }
    return Intersections.new(intersections.collect { |i| i[0] })
  end
end

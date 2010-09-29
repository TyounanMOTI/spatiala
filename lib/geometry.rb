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
    intersect(ray).first[:target_ray]
  end

  def occluded?(ray)
    not lines_include_vertex(ray.destination).include?(nearest_intersect_line_with(ray))
  end

  def intersect(ray)
    lines.map { |i| {:ratio => ray.intersect(i), :target_ray => i} }.delete_if { |i| i[:ratio].nil? }.sort_by { |i| i[:ratio] }
  end
end

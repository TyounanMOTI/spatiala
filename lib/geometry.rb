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
    lines.map { |i| [i.origin, i.destination] }.flatten
  end

  def lines_include_vertex(vertex)
    result = self.lines.map { |i| i if i.origin == vertex || i.destination == vertex }.compact
  end

  def nearest_intersect_line_with(ray)
    intersect(ray).first[1]
  end

  def occluded?(ray)
    not lines_include_vertex(ray.destination).include?(nearest_intersect_line_with(ray))
  end

  def intersect(ray)
    lines.map { |i| [ray.intersect(i), i] }.delete_if { |i| i[0].nil? }.sort_by { |i| i[0] }
  end
end

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

  def lines_include_vertex(vertex)
    self.lines.map { |i| i if i.origin == vertex || i.destination == vertex }.compact
  end

  def nearest_intersect_line_with(ray)
    intersections = lines.map { |i| [ray.intersect(i), i.intersect(ray), i] }.delete_if { |i| i[0] < 0 || i[1] > 1 || i[1] < 0 }.sort
    return intersections.first[2]
  end
end

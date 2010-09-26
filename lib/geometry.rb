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
end

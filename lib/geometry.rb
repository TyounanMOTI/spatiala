require 'polygon'

class Geometry
  attr_reader :polygons

  def initialize(*polygons)
    @polygons = polygons.flatten
  end

  def vertices
    vertices = Array.new
    @polygons.each { |i| vertices.push i.vertices }
    return vertices.flatten
  end

  def lines
    lines = Array.new
    @polygons.each { |i| lines.push i.lines }
    return lines.flatten
  end

  def lines_include_vertex(vertex)
    result = Array.new
    self.lines.each { |i| result.push i if i.origin == vertex || i.destination == vertex }
    return result
  end
end

require 'polygon'

class Geometry
  attr_reader :polygons

  def initialize(*polygons)
    @polygons = polygons
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
end

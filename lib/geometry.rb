require 'polygon'

class Geometry
  attr_reader :polygons

  def initialize(*polygons)
    @polygons = polygons
  end

  def get_all_vertices
    vertices = Array.new
    @polygons.each { |i| vertices.push i.vertices }
    return vertices.flatten
  end
end

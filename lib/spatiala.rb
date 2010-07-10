require 'geometry'
require 'polygon'
require 'ray'
require 'vector'

class Spatiala < Processing::App
  def setup
    size 640, 640
    smooth

    triangle = Polygon.new(Vector.new(10,20),
                           Vector.new(400,50),
                           Vector.new(30,420))

    @geometry = Geometry.new(triangle)

    draw_geometry
  end

  def draw
  end

  def draw_polygon(polygon)
    polygon.lines.each { |i| line(i.origin.x, i.origin.y, i.destination.x, i.destination.y) }
  end

  def draw_geometry
    @geometry.polygons.each { |i| draw_polygon(i) }
  end
end

Spatiala.new

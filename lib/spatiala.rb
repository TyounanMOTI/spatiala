require 'polygon'
require 'ray'
require 'vector'

class Spatiala < Processing::App
  def setup
    size 640, 640
    smooth

    polygon = Polygon.new(Vector.new(10,20),
                            Vector.new(400,50),
                            Vector.new(30,420))

    draw_polygon(polygon)
  end

  def draw
  end

  def draw_polygon(polygon)
    geometry.lines.each { |i| line(i.origin.x, i.origin.y, i.destination.x, i.destination.y)}
  end
end

Spatiala.new

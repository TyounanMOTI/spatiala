require 'geometry'
require 'ray'
require 'vector'

class Spatiala < Processing::App
  def setup
    size 640, 640
    smooth

    geometry = Geometry.new(Vector.new(10,20),
                            Vector.new(400,50),
                            Vector.new(30,420))

    draw_geometry(geometry)
  end

  def draw
  end

  def draw_geometry(geometry)
    geometry.lines.each { |i| line(i.origin.x, i.origin.y, i.destination.x, i.destination.y)}
  end
end

Spatiala.new

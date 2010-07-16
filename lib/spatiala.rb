require 'source'
require 'listener'
require 'geometry'
require 'polygon'
require 'ray'
require 'vector'
require 'beam_tracer'
require 'crack_list'
require 'crack'

class Spatiala < Processing::App
  def setup
    size 640, 640
    frame_rate 1
    smooth
    color_mode HSB, 100
    @hue = 60
    @saturation = 20
    @brightness = 80
    background @hue, @saturation, @brightness-50
    stroke @hue, 20, @brightness

    triangle = Polygon.new(Vector.new(10,20),
                           Vector.new(400,50),
                           Vector.new(30,420))
    wall = Polygon.new(Vector.new(100, 100),
                       Vector.new(250, 130))

    @geometry = Geometry.new(triangle, wall)

    @sources = Array.new
    @sources.push(Source.new(Vector.new(50,50)))

    @listener = Listener.new(Vector.new(120,160),
                             Vector.new(30,30))

    draw_geometry
    draw_listener
    draw_source

    @tracer = BeamTracer.new(@geometry, @sources, @listener)
    @crack_list = @tracer.make_crack_list
    @index = 0
  end

  def draw
    refresh
    @index = 0 if @index >= @crack_list.cracks.length
    @crack_list.cracks[@index].rays.each { |i| draw_ray i }
    @index += 1
  end

  def refresh
    clear
    draw_geometry
    draw_listener
    draw_source
  end

  def clear
    push_style

    stroke_weight 0
    fill @hue, @saturation, @brightness-50
    rect 0, 0, width, height

    pop_style
  end

  def draw_polygon(polygon)
    polygon.lines.each { |i| line(i.origin.x, i.origin.y, i.destination.x, i.destination.y) }
  end

  def draw_geometry
    @geometry.polygons.each { |i| draw_polygon(i) }
  end

  def draw_listener
    push_style

    stroke_weight 3
    color_mode HSB, 100
    stroke @hue-30, @saturation, @brightness, 90
    fill @hue-30, @saturation, @brightness, 40

    draw_point(@listener.position.x, @listener.position.y)

    pop_style
  end

  def draw_source
    push_style

    stroke_weight 3
    color_mode HSB, 100
    stroke @hue+30, @saturation, @brightness, 90
    fill @hue+30, @saturation, @brightness, 40

    @sources.each { |i| draw_point(i.position.x, i.position.y) }

    pop_style
  end

  def draw_point(x, y)
    ellipse x, y, 8, 8
  end

  def draw_ray(ray)
    push_style

    stroke_weight 3
    color_mode HSB, 100
    stroke 18, @saturation, @brightness, 100
    fill @hue, @saturation, @brightness, 80
    line ray.origin.x, ray.origin.y, ray.destination.x, ray.destination.y
    draw_point ray.origin.x, ray.origin.y

    pop_style
  end
end

Spatiala.new

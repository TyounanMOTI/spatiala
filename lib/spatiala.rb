require 'source'
require 'listener'
require 'geometry'
require 'polygon'
require 'ray'
require 'vector'
require 'beam_tracer'
require 'crack_list'
require 'crack'
require 'beam'
require './matrix'

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

    @tracer = BeamTracer.new(@geometry, @sources, @listener)
    @crack_list = @tracer.make_crack_list
    @beams = @crack_list.to_beams

    @normalized_tracer = @tracer.normalize @beams[2].reference_segment

    @index = 0
  end

  def draw
    clear
    draw_geometry width/2, height/2

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

  def draw_polygon(polygon, x=0, y=0)
    polygon.lines.each { |i| line(i.origin.x + x, i.origin.y + y, i.destination.x + x, i.destination.y + y) }
  end

  def draw_geometry(x=0, y=0)
    draw_axis x, y
    @geometry.polygons.each { |i| draw_polygon(i, x, y) }
  end

  def draw_axis(x, y)
    push_style

    stroke_weight 1
    stroke 0, @saturation, 70
    line 10, y, width - 10, y # x-axis
    line x, 10, x, height - 10 # y-axis

    pop_style
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

  def draw_beam(beam)
    beam.deltas.each { |i| draw_ray i }
  end

  def key_released
    save_frame "../snap/spatiala-####.png" if key == 'p'
  end
end

Spatiala.new

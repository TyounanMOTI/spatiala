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
require 'visibility_map'
require 'visibility_region'

class Spatiala < Processing::App
  def setup
    size 600, 400
    frame_rate 1
    smooth
    color_mode HSB, 100
    @hue = 60
    @saturation = 20
    @brightness = 80
    background @hue, @saturation, @brightness-50
    stroke @hue, 20, @brightness
    @scale = Vector.new(1,height/2 - 20)
    @offset = Vector.new(width/2, height/2)

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
    draw_axis
    draw_geometry @normalized_tracer.geometry

    draw_listener @normalized_tracer.listener
    draw_source @normalized_tracer.sources
  end

  def clear
    push_style

    stroke_weight 0
    fill @hue, @saturation, @brightness-50
    rect 0, 0, width, height

    pop_style
  end

  def draw_polygon(polygon)
    polygon.lines.each { |i| line(i.origin.x*@scale.x + @offset.x,
                                  i.origin.y*@scale.y + @offset.y,
                                  i.destination.x*@scale.x + @offset.x,
                                  i.destination.y*@scale.y + @offset.y) }
  end

  def draw_geometry(geometry = @geometry)
    geometry.polygons.each { |i| draw_polygon i }
  end

  def draw_axis
    margin = 10
    push_style

    stroke_weight 1
    stroke 0, @saturation, 70
    line margin, @offset.y, width - margin, @offset.y # x-axis
    line @offset.x, margin, @offset.x, height - margin # y-axis

    pop_style
  end

  def draw_listener(listener = @listener)
    push_style

    stroke_weight 3
    color_mode HSB, 100
    stroke @hue-30, @saturation, @brightness, 90
    fill @hue-30, @saturation, @brightness, 40

    draw_point(listener.position.x*@scale.x + @offset.x,
               listener.position.y*@scale.y + @offset.y)

    pop_style
  end

  def draw_source(sources = @sources)
    push_style

    stroke_weight 3
    color_mode HSB, 100
    stroke @hue+30, @saturation, @brightness, 90
    fill @hue+30, @saturation, @brightness, 40

    sources.each { |i| draw_point(i.position.x*@scale.x + @offset.x,
                                  i.position.y*@scale.y + @offset.y) }

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
    line(ray.origin.x*@scale.x + @offset.x,
         ray.origin.y*@scale.y + @offset.y,
         ray.destination.x*@scale.x + @offset.x,
         ray.destination.y*@scale.y + @offset.y)
    draw_point(ray.origin.x*@scale.x + @offset.x,
               ray.origin.y*@scale.y + @offset.y)

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

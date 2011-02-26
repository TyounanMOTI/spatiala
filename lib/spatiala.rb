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
require 'intersection'

class Spatiala < Processing::App
  def setup
    p "============"
    setup_app
    setup_tracer

    reflector_index = 1
    @reflector = @geometry.lines[reflector_index]
    @map = VisibilityMap.new(@geometry, @reflector)
    @normalized_listener = @listener.normalize(@map.reflected_normalizer)
    @intersection_points = @map.intersection_points(@normalized_listener)

    case :normalized
    when :normalized
      scale_for_normalized_geometry
      draw_geometry @map.geometry
      draw_listener @normalized_listener
      draw_ray @map.geometry.lines[reflector_index]

      intersection_points = @map.intersection_points(@normalized_listener)
      draw_intersection_points intersection_points
      draw_rays intersection_points.map { |i| i.dualize }

    when :world
      scale_for_geometry
      draw_geometry

      intersection_rays = @geometry.connect_listener_vertices(@listener)
      draw_rays @geometry.reject_occluded_rays(intersection_rays).to_a

    when :map
      scale_for_visibility_map
      draw_axis

      draw_visibility_map @map
      draw_ray @normalized_listener.position.dualize
      draw_intersection_points @map.intersections_with_regions(@normalized_listener)

    when :sandbox
      @scale = Vector.new(150,-150)
      @offset = Vector.new(width/2, height/2)
      draw_axis
      draw_point 0, 1
      draw_point 0,-1

      ray = Ray.new(Vector.new(-1,-1), Vector.new(1,1))
      theta = Math.atan(ray.origin.y.to_f/ray.origin.x.to_f)

      draw_ray ray

      rotated = ray.transform(Matrix::Rotator[Math::PI/2-theta])
      draw_ray rotated, @hue-20
      draw_ray rotated.transform(Matrix::Scaler[1,1/rotated.origin.y.abs]), @hue+20
    end

    @region_index = 0
    @ray_index = 0
  end

  def draw
    case :none
    when :intersection
      clear
      region = @map.regions[@region_index]
      ray = @map.regions[@region_index].rays[@ray_index]
      rate = @vision.intersect(ray)
      intersection_point = (@vision*rate).destination unless rate.nil?

      draw_axis
      draw_polygon region
      draw_ray ray
      draw_ray @vision
      draw_point intersection_point unless rate.nil?

      each_millis(1000) do
        @ray_index += 1
        if @ray_index == @map.regions[@region_index].rays.length
          @ray_index = 0
          @region_index += 1
        end
        @region_index = 0 if @region_index == @map.regions.length
      end
    when :reflector
    end
  end

  def setup_app
    size 700, 500
    frame_rate 30
    smooth
    color_mode HSB, 100
    @hue = 60
    @saturation = 20
    @brightness = 80
    background @hue, @saturation, @brightness-50
    stroke @hue, 20, @brightness
    @previous_millis = millis
  end

  def setup_tracer
    triangle = Polygon.new(Vector.new(10,20),
                           Vector.new(400,50),
                           Vector.new(30,420))
    wall = Polygon.new(Vector.new(100, 100),
                       Vector.new(250, 130))
    wall2 = Polygon.new(Vector.new(150, 90),
                        Vector.new(200, 100))
    @geometry = Geometry.new(triangle, wall, wall2)

#    wall = Polygon.new(Vector.new(130,30),
#                       Vector.new(100,300))
#   @geometry = Geometry.new(triangle, wall)

    @sources = Array.new
    @sources.push(Source.new(Vector.new(50,50)))

    @listener = Listener.new(Vector.new(100,200),
                             Vector.new(30,30))

#    @tracer = BeamTracer.new(@geometry, @sources, @listener)
  end

  def scale_for_geometry
    @scale = Vector.new(1,1)
    @offset = Vector.new(0,0)
  end

  def scale_for_normalized_geometry
    @scale = Vector.new(1, 200)
    @offset = Vector.new(width/4, height/2)
  end

  def scale_for_visibility_map
    @scale = Vector.new(15000, height/2 - 20)
    @offset = Vector.new(width/2, height/2)
  end

  def print_regions
    @regions.each do |region|
      Kernel.print "\n<<< REGION : "
      print_ray(region.original)
      region.rays.each { |i| print_ray(i) }
    end
  end

  def print_geometry
    Kernel.print "\n+++ Geometry +++\n"
    @normalized_tracer.geometry.lines.each { |i| print_ray(i) }
  end

  def draw_intersection_points(intersection_points)
    push_style
    fill @hue+30, @saturation, @brightness, 50

    intersection_points.each { |i| draw_point(i.point) }

    pop_style
  end

  def draw_visibility_map(map)
    hue = 0
    map.regions.each do |region|
      hue += 100/map.regions.length
      region.rays.each { |ray| draw_ray ray, hue, 50 }
    end
  end

  def print_ray(ray)
    Kernel.print "- Ray (%5.1f" % ray.origin.x, ",%5.1f" % ray.origin.y, ") to (%5.1f" % ray.destination.x, ",%5.1f" % ray.destination.y, ")\n"
  end

  def clear
    push_style

    stroke_weight 0
    fill @hue, @saturation, @brightness-50
    rect 0, 0, width, height

    pop_style
  end

  def draw_polygon(polygon, weight=1, hue=@hue, alpha=0)
    push_style

    stroke_weight weight
    color_mode HSB, 100
    stroke hue, @saturation, @brightness, 100
    fill hue, @saturation, @brightness-20, alpha

    begin_shape
    polygon.vertices.each { |i| vertex(i.x*@scale.x + @offset.x,
                                       i.y*@scale.y + @offset.y) }
    end_shape CLOSE
    pop_style
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

    draw_point(listener.position)

    pop_style
  end

  def draw_source(sources = @sources)
    push_style

    stroke_weight 3
    color_mode HSB, 100
    stroke @hue+30, @saturation, @brightness, 90
    fill @hue+30, @saturation, @brightness, 40

    sources.each { |i| draw_point(i.position) }

    pop_style
  end

  def draw_point(x, y=0)
    case x
    when Vector
      ellipse x.x*@scale.x + @offset.x, x.y*@scale.y + @offset.y, 8, 8
    else
      ellipse x*@scale.x + @offset.x, y*@scale.y + @offset.y, 8, 8
    end
  end

  def draw_ray(ray, hue=@hue, alpha=100)
    push_style

    stroke_weight 3
    color_mode HSB, 100
    stroke hue, @saturation, @brightness, alpha
    fill hue, @saturation, @brightness-20, alpha
    line(ray.origin.x*@scale.x + @offset.x,
         ray.origin.y*@scale.y + @offset.y,
         ray.destination.x*@scale.x + @offset.x,
         ray.destination.y*@scale.y + @offset.y)
    draw_point(ray.origin)

    pop_style
  end

  def draw_rays(rays)
    hue = 0
    rays.each do |i|
      draw_ray i, hue, 50
      hue += 100 / rays.length
    end
  end

  def draw_beam(beam, hue=@hue, alpha=0)
    draw_polygon(beam, 3, hue, alpha)
  end

  def draw_beams(beams)
    hue = 0
    beams.each do |i|
      draw_beam i, hue, 50
      hue += 100 / beams.length
    end
  end

  def key_released
    save_frame "../snap/spatiala-####.png" if key == 'p'
  end

=begin
  def mouse_pressed
    push_style

    stroke_weight 3
    stroke @hue+10, @saturation, @brightness
    fill @hue+10, @saturation, @brightness, 50
    ellipse mouse_x, mouse_y, 8, 8

    p "#{mouse_x}, #{mouse_y}"

    pop_style
  end
=end

  def each_millis(interval, &block)
    if millis - @previous_millis >= interval
      yield
      @previous_millis = millis
    end
  end
end

Spatiala.new

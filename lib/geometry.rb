require 'polygon'

class Geometry
  attr_reader :polygons

  def initialize(*polygons)
    @polygons = polygons.flatten
  end

  def vertices
    @polygons.map { |i| i.vertices }.flatten
  end

  def lines
    @polygons.map { |i| i.lines }.flatten
  end

  def ends_of_lines
    lines.map do |line|
      [line.origin, line.destination].map { |vertex| {:vertex => vertex, :line => line} }
    end.flatten
  end

  def lines_include(point)
    lines.select { |i| i.include?(point) }
  end

  def nearest_intersect_line_with(ray)
    return nil if intersect(ray).empty?
    return intersect(ray).first.target_ray
  end

  def occlude?(ray)
    return false if ray.length == 0
    return (not lines_include(ray.destination).include?(nearest_intersect_line_with(ray)))
  end

  def intersect(ray)
    intersections = lines.map { |line| [Intersection.new(ray.origin, line, [line.intersect(ray)]), ray.intersect(line)] }.delete_if { |i| i[1].nil? }.sort_by { |i| i[1] }
    return Intersections.new(intersections.collect { |i| i[0] })
  end

  def normalize(window)
    return transform(normalizer(window))
  end

  def normalizer(window)
    window_center = (window.origin + window.destination)/2
    translator = Matrix::Translator[-window_center.x, -window_center.y, -window_center.z]
    translated_window = window.transform(translator)
    theta = Math.atan(translated_window.origin.y.to_f / translated_window.origin.x.to_f)
    rotator = Matrix::Rotator[Math::PI/2 - theta]
    rotated_window = translated_window.transform(rotator)
    scaler = Matrix::Scaler[1,1/rotated_window.origin.y]
    return translator * rotator * scaler
  end

  def transform(matrix)
    polygons = @polygons.map { |i| i.transform(matrix) }
    return Geometry.new(polygons)
  end

  def without_window
    Geometry.new(@polygons.map { |i| i.disable(Ray::WINDOW) })
  end
end

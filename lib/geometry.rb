require 'polygon'

class Geometry
  attr_reader :polygons

  def initialize(*polygons)
    @polygons = polygons.flatten
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

  def lines_include_vertex(vertex)
    result = Array.new
    self.lines.each { |i| result.push i if i.origin == vertex || i.destination == vertex }
    return result
  end

  def normalize(segment)
    normalizer = self.normalizer(segment)
    polygons = @polygons.map do |polygon|
      polygon.transform(normalizer)
    end
    return Geometry.new(polygons)
  end

  def normalizer(segment)
    segment_center = (segment.origin + segment.destination)/2
    translator = Matrix.get_translator(-segment_center.x, -segment_center.y, -segment_center.z)
    translated_segment = segment.transform(translator)
    theta = Math.atan(translated_segment.origin.y.to_f / translated_segment.origin.x.to_f)
    rotator = Matrix.get_rotator(Math::PI/2 - theta)
    rotated_segment = translated_segment.transform(rotator)
    scaler = Matrix.get_scale(1,1/rotated_segment.origin.y)
    return translator * rotator * scaler
  end
end

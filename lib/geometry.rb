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

  def normalizer(segment)
    segment_center = Vector.new((segment.origin.x + segment.destination.x)/2, (segment.origin.y + segment.destination.y)/2)
    translator = Matrix.get_translator(-segment_center.x, -segment_center.y, -segment_center.z)
    translated_segment = segment.transform(translator)
    theta = Math.atan(translated_segment.origin.x / translated_segment.origin.y)
    rotator = Matrix.get_rotator(theta)
    rotated_segment = translated_segment.transform(rotator)
    scaler = Matrix.get_scale(1,1/rotated_segment.origin.y)
    return translator * rotator * scaler
  end
end

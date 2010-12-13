require 'ray'

class Polygon
  attr_reader :vertices, :disabled

  def initialize(*vertices)
    @vertices = vertices.flatten
    @disabled = Array.new
  end

  def lines
    result = Array.new
    if @vertices.length == 2 then
      result << Ray.new(@vertices[0], @vertices[1]) unless disabled?(0,1)
    else
      @vertices.each_index do |i|
        next if (@vertices[i+1].nil? && disabled?(i, 0)) || disabled?(i, i+1)
        result << Ray.new(@vertices[i], @vertices.fetch(i+1, @vertices[0]))
      end
    end
    return result
  end

  def transform(matrix)
    vertices = @vertices.map { |i| i.transform(matrix) }
    return Polygon.new(vertices)
  end

  def disable(line)
    polygon = Polygon.new(@vertices)
    disabled_vertices = [@vertices.index(line.origin), @vertices.index(line.destination)]
    polygon.disabled << disabled_vertices unless disabled_vertices.nil? && polygon.disabled.include?(disabled_vertices)
    return polygon
  end

  def disabled?(v1, v2)
    index = @disabled.assoc(v1)
    return true if !index.nil? && index[1] == v2
    index = @disabled.rassoc(v1)
    return true if !index.nil? && index[0] == v2
    return false
  end

  def include?(point)
    lines.detect { |i| i.delta.cross(point - i.origin).z < 0 }.nil?
  end
end

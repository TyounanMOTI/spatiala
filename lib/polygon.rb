require 'ray'

class Polygon
  attr_reader :vertices, :disabled

  def initialize(*vertices)
    @vertices = vertices.flatten
    @disabled = Array.new
  end

  def lines
    result = Array.new
    if vertices.length == 2 then
      result.push Ray.new(vertices[0], vertices[1])
    else
      @vertices.each_index { |i| result.push(Ray.new(@vertices[i], @vertices.fetch(i+1, @vertices[0])))}
    end
    return result
  end

  def transform(matrix)
    vertices = @vertices.map { |i| i.transform(matrix) }
    return Polygon.new(vertices)
  end

  def disable!(line)
    disabled_vertices = [vertices.index(line.origin), vertices.index(line.destination)]
    @disabled << disabled_vertices unless @disabled.include?(disabled_vertices)
  end

  def disabled?(v1, v2)
    index = @disabled.assoc(v1)
    return true if !index.nil? && index[1] == v2
    index = @disabled.rassoc(v2)
    return true if !index.nil? && index[0] == v2
    return false
  end
end

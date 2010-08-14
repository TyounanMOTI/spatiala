require 'ray'

class Polygon
  attr_reader :vertices

  def initialize(*vertices)
    @vertices = vertices.flatten
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
end

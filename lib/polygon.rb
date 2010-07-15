require 'ray'

class Polygon
  attr_reader :vertices

  def initialize(*vertices)
    @vertices = vertices
  end

  def lines
    result = Array.new
    @vertices.each_index { |i| result.push(Ray.new(@vertices[i], @vertices.fetch(i+1, @vertices[0])))}
    return result
  end
end

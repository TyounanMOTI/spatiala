class Geometry
  def initialize(*vertex)
    @vertex = vertex
  end

  def lines
    result = Array.new
    @vertex.each_index { |i| result.push(Ray.new(@vertex[i], @vertex.fetch(i+1, @vertex[0])))}
    return result
  end
end

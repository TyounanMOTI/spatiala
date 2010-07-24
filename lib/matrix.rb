class Matrix
  attr_reader :vectors

  def initialize(*vectors)
    @vectors = vectors
    @vectors[3].w = 1
  end

  def row(i)
    return @vectors[i]
  end

  def column(i)
    result = Vector.new
    @vectors.each_index { |v| result[v] = @vectors[v][i]}
    return result
  end

  def ==(m)
    return true if @vectors == m.vectors
    return false
  end
end

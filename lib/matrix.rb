class Matrix
  attr_reader :vectors

  def initialize(*vectors)
    @vectors = vectors
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

  def *(m)
    result = Matrix.new
    @vectors.each_index do |i|
      result.vectors[i] = Vector.new
      @vectors[i].each_with_index do |e, j|
        result.vectors[i][j] = self.row(i) * m.column(j)
      end
    end
    return result
  end
end

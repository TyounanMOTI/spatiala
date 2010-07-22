class Matrix
  def initialize(*vectors)
    @vectors = vectors
  end

  def row(i)
    return @vectors[i]
  end
end

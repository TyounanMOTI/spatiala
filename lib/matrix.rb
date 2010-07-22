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
    case i
    when 0
      Vector.new(@vectors[0].x,
                 @vectors[1].x,
                 @vectors[2].x,
                 @vectors[3].x)
    when 1
      Vector.new(@vectors[0].y,
                 @vectors[1].y,
                 @vectors[2].y,
                 @vectors[3].y)
    when 2
      Vector.new(@vectors[0].z,
                 @vectors[1].z,
                 @vectors[2].z,
                 @vectors[3].z)
    end
  end

  def ==(m)
    return true if @vectors == m.vectors
    return false
  end
end

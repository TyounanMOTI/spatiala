class Matrix
  extend Math
  attr_reader :vectors

  def initialize(*vectors)
    @vectors = vectors.flatten
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

  def self.translator(x,y=0,z=0)
    Matrix.new(Vector.new(1,0,0,0),
               Vector.new(0,1,0,0),
               Vector.new(0,0,1,0),
               Vector.new(x,y,z,1))
  end

  def self.rotator(radian)
    Matrix.new(Vector.new(cos(radian), sin(radian), 0, 0),
               Vector.new(-sin(radian),cos(radian), 0, 0),
               Vector.new(0, 0, 1, 0),
               Vector.new(0, 0, 0, 1))
  end

  def self.scaler(x,y,z=1)
    Matrix.new(Vector.new(x, 0, 0, 0),
               Vector.new(0, y, 0, 0),
               Vector.new(0, 0, z, 0),
               Vector.new(0, 0, 0, 1))
  end

  def self.reflector(normal)
    x = normal.x
    y = normal.y
    z = normal.z
    Matrix.new(Vector.new(1 - 2*(x**2), -2*x*y, -2*x*z,0),
               Vector.new(-2*x*y, 1 - 2*(x**2), -2*y*z,0),
               Vector.new(-2*x*z, -2*y*z, 1 - 2*(z**2),0),
               Vector.new(0,0,0,1))
  end
end

class Matrix < Array
  extend Math
  attr_accessor :transforms

  def initialize(*vectors)
    super vectors.flatten
    @transforms = [self]
  end

  def self.[](*vectors)
    Matrix.new(vectors.map { |i| Vector.new(i) })
  end

  def row(i)
    return self[i]
  end

  def column(i)
    result = Vector.new
    each_index { |v| result[v] = self[v][i] }
    return result
  end

  def *(m)
    result = Matrix.new
    each_index do |i|
      result[i] = Vector.new
      self[i].each_with_index do |e, j|
        result[i][j] = self.row(i) * m.column(j)
      end
    end
    result.transforms = @transforms + m.transforms
    return result
  end

  def inverse
    @transforms.reverse.inject(I_4.new) { |result, i| result*(i.inverse) }
  end

  class Translator < Matrix
    def initialize(x,y,z=0)
      @x, @y, @z = x, y, z
      super [
             Vector[1,0,0,0],
             Vector[0,1,0,0],
             Vector[0,0,1,0],
             Vector[x,y,z,1]
            ]
    end

    def self.[](x,y,z=0)
      Translator.new(x,y,z)
    end

    def inverse
      Translator[-@x,-@y,-@z]
    end
  end

  class Scaler < Matrix
    def initialize(x,y,z=1)
      @x, @y, @z = [x, y, z].map { |i| i.to_f }
      super [
             Vector[x,0,0,0],
             Vector[0,y,0,0],
             Vector[0,0,z,0],
             Vector[0,0,0,1]
            ]
    end

    def self.[](x,y,z=1)
      Scaler.new(x,y,z)
    end

    def inverse
      Scaler[1/@x, 1/@y, 1/@z]
    end
  end

  class Reflector < Matrix
    def initialize(x,y,z)
      @x,@y,@z = x,y,z
      super [
             Vector[1 - 2*(x**2), -2*x*y, -2*x*z,0],
             Vector[-2*x*y, 1 - 2*(y**2), -2*y*z,0],
             Vector[-2*x*z, -2*y*z, 1 - 2*(z**2),0],
             Vector[0,0,0,1]
            ]
    end

    def self.[](x,y,z)
      Reflector.new(x,y,z)
    end

    def inverse
      Reflector[-@x,-@y,-@z]
    end
  end

  class Rotator < Matrix
    def initialize(radian)
      @radian = radian
      super [
             Vector[Math::cos(radian), Math::sin(radian), 0,0],
             Vector[-Math::sin(radian),Math::cos(radian), 0,0],
             Vector[0,0,1,0],
             Vector[0,0,0,1]
            ]
    end

    def self.[](radian)
      Rotator.new(radian)
    end

    def inverse
      Rotator[-@radian]
    end
  end

  class Matrix::I_4 < Matrix
    def initialize
      super [
             Vector[1,0,0,0],
             Vector[0,1,0,0],
             Vector[0,0,1,0],
             Vector[0,0,0,1]
            ]
    end

    def inverse
      I_4.new
    end
  end
end

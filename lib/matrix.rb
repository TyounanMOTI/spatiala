class Matrix < Array
  extend Math
  attr_accessor :transforms

  def initialize(*vectors)
    @transforms = [self]
    super vectors.flatten
  end

  def self.[](*vectors)
    Matrix.new(vectors.map { |i| Vector.new(i) })
  end

  def self.I_4
    Matrix[
           [1,0,0,0],
           [0,1,0,0],
           [0,0,1,0],
           [0,0,0,1]
          ]
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
               Vector.new(-2*x*y, 1 - 2*(y**2), -2*y*z,0),
               Vector.new(-2*x*z, -2*y*z, 1 - 2*(z**2),0),
               Vector.new(0,0,0,1))
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
      super [
             Vector[cos(radian), sin(radian), 0,0],
             Vector[-sin(radian),cos(radian), 0,0],
             Vector[0,0,1,0],
             Vector[0,0,0,1]
            ]
    end

    def self.[](radian)
      Rotator.new(radian)
    end
  end
end

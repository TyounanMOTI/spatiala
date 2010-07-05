class Vector
  attr_accessor :x, :y, :z, :w

  def initialize(x=0, y=0, z=0)
    @x = x
    @y = y
    @z = z
    @w = 1
  end

  def *(v)
    case v
      when Vector then @x*v.x + @y*v.y + @z*v.z
      else Vector.new(@x*v, @y*v, @z*v)
    end
  end

  def cross(v)
    Vector.new(@y*v.z - @z*v.y,
               @z*v.x - @x*v.z,
               @x*v.y - @y*v.x)
  end

  def +(v)
    Vector.new(@x + v.x, @y + v.y, @z + v.z)
  end

  def -(v)
    Vector.new(@x - v.x, @y - v.y, @z - v.z)
  end

  def -@
    Vector.new(-@x, -@y, -@z)
  end

  def /(a)
    Vector.new(@x/a, @y/a, @z/a)
  end

  def ==(v)
    @x == v.x && @y == v.y && @z == v.z && @w == v.w
  end

  def !=(v)
    not (self == v)
  end

  def length
    Math.sqrt(@x**2 + @y**2 + @z**2)
  end

  def normalize
    self / self.length
  end
end

class Vector
  attr_accessor :x, :y, :z, :w

  def initialize(x=0, y=0, z=0, w=0)
    @x = x
    @y = y
    @z = z
    @w = w
  end

  def *(v)
    case v
      when Vector then @x*v.x + @y*v.y + @z*v.z + @w*v.w
      else Vector.new(@x*v, @y*v, @z*v, @w*v)
    end
  end

  def cross(v)
    Vector.new(@y*v.z - @z*v.y,
               @z*v.x - @x*v.z,
               @x*v.y - @y*v.x)
  end

  def +(v)
    Vector.new(@x + v.x, @y + v.y, @z + v.z, @w + v.w)
  end

  def -(v)
    Vector.new(@x - v.x, @y - v.y, @z - v.z, @w - v.w)
  end

  def -@
    Vector.new(-@x, -@y, -@z, -@w)
  end

  def /(a)
    Vector.new(@x/a, @y/a, @z/a, @w/a)
  end

  def ==(v)
    @x == v.x && @y == v.y && @z == v.z && @w == v.w
  end

  def length
    Math.sqrt(@x**2 + @y**2 + @z**2 + @w**2)
  end

  def normalize
    self / self.length
  end
end

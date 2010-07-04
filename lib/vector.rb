class Vector
  attr_accessor :x, :y, :z, :w

  def initialize(x=0, y=0, z=0)
    @x = x
    @y = y
    @z = z
    @w = 1
  end

  def *(v)
    @x*v.x + @y*v.y + @z*v.z
  end

  def cross(v)
    Vector.new(@y*v.z - @z*v.y,
               @z*v.x - @x*v.z,
               @x*v.y - @y*v.x)
  end

  def +(v)
    Vector.new(@x + v.x, @y + v.y, @z + v.z)
  end
end

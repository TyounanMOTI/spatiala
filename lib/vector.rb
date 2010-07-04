class Vector
  attr_accessor :x, :y, :z, :w

  def initialize(x=0, y=0, z=0)
    @x = x
    @y = y
    @z = z
    @w = 1
  end
end

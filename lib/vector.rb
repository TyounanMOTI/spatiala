class Vector
  attr_reader :x, :y, :z, :w, :elements

  def initialize(*elements)
    @elements = elements
    @x = @elements.fetch(0, 0)
    @y = @elements.fetch(1, 0)
    @z = @elements.fetch(2, 0)
    @w = @elements.fetch(3, 0)
  end

  def x=(x)
    @elements[0] = x
    @x = x
  end

  def y=(y)
    @elements[1] = y
    @y = y
  end

  def z=(z)
    @elements[2] = z
    @z = z
  end

  def w=(w)
    @elements[3] = w
    @w = w
  end

  def [](i)
    return 0 if i >= @elements.length
    return @elements[i]
  end

  def []=(key, value)
    case key
    when 0
      self.x = value
    when 1
      self.y = value
    when 2
      self.z = value
    when 3
      self.w = value
    else
      @elements[key] = value
    end
  end

  def *(v)
    case v
    when Vector
      product = 0
      @elements.each_index { |i| product += self[i]*v[i]}
      return product
    else
      result = Vector.new
      @elements.each_index { |i| result[i] = self[i]*v }
      return result
    end
  end

  def cross(v)
    Vector.new(@y*v.z - @z*v.y,
               @z*v.x - @x*v.z,
               @x*v.y - @y*v.x)
  end

  def +(v)
    result = Vector.new
    @elements.each_index { |i| result[i] = self[i] + v[i] }
    return result
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

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
    result = Vector.new
    @elements.each_index { |i| result[i] = self[i] - v[i] }
    return result
  end

  def -@
    result = Vector.new
    @elements.each_index { |i| result[i] = - self[i] }
    return result
  end

  def /(a)
    result = Vector.new
    @elements.each_index { |i| result[i] = self[i] / a }
    return result
  end

  def ==(v)
    @elements == v.elements
  end

  def length
    sum = 0
    @elements.each { |i| sum += i**2 }
    return Math.sqrt sum
  end

  def normalize
    self / self.length
  end
end

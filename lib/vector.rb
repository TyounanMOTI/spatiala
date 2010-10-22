class Vector
  include Enumerable
  attr_reader :x, :y, :z, :w, :elements

  def initialize(*elements)
    elements.flatten!
    @elements = elements.map { |i| i.to_f }
    self.x = @elements.fetch(0, 0).to_f
    self.y = @elements.fetch(1, 0).to_f
    self.z = @elements.fetch(2, 0).to_f
    self.w = @elements.fetch(3, 0).to_f
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
    (self - v).length < 0.0000001
  end

  def length
    sum = 0
    @elements.each { |i| sum += i**2 }
    return Math.sqrt sum
  end

  def normalize
    self / self.length
  end

  def each
    @elements.each { |v| yield v }
  end

  def transform(matrix)
    self_matrix = Matrix.new(Vector.new(@x,@y,@z,1),
                             Vector.new(0,1,0,0),
                             Vector.new(0,0,1,0),
                             Vector.new(0,0,0,1))
    product = self_matrix * matrix
    result = product.row(0)
    return Vector.new(result.x, result.y, result.z).snap
  end

  def snap
    epsilon = 1.0e-10
    elements = @elements.map do |i|
      if (i - i.round).abs < epsilon
        i.round
      else
        i
      end
    end
    return Vector.new(elements)
  end

  def dualize
    source = Vector.new((@y - 1)/@x, 1)
    dest = Vector.new((@y + 1)/@x, -1)
    return Ray.new(source, dest)
  end

  def hash
    return @elements.join.hash
  end

  def eql?(obj)
    return hash == obj.hash
  end
end

class CrackList
  include Enumerable
  attr_reader :cracks

  def initialize(*args)
    case args.flatten[0]
    when Crack
      @cracks = args.flatten
    when Geometry
      @geometry = args.shift
      @listener = args.shift
      @cracks = initialize_from_geometry_and_listener
    else
      @cracks = Array.new
    end
  end

  def initialize_from_geometry_and_listener
    return Array.new
  end

  def connect_listener_and_vertices
    @geometry.ends_of_lines.map { |vertex| Ray.new(@listener.position, vertex) }
  end

  def append(crack)
    i = @cracks.index { |j| j.line == crack.line }
    unless i then
      @cracks.push crack
    else
      @cracks[i].rays.push crack.rays
      @cracks[i].rays.flatten!
    end
  end

  def [](i)
    return @cracks[i]
  end

  def length
    return @cracks.length
  end

  def each
    @cracks.each do |crack|
      yield crack
    end
  end

  def to_beams
    list = Array.new
    self.each { |i| list << i.to_beam }
    return list
  end
end

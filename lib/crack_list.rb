class CrackList
  include Enumerable
  attr_reader :cracks

  def initialize(*cracks)
    @cracks = cracks
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

  def each
    @cracks.each do |crack|
      yield crack
    end
  end
end

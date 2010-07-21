class Crack
  attr_accessor :line, :rays

  def initialize(line, *rays)
    @line = line
    @rays = rays
  end

  def sort!
    if (@rays[0].delta.cross(@rays[1].delta)).z < 0
      @rays.reverse!
    end
  end

  def to_beam
    beam = Beam.new(@rays[0].origin,
                    @rays[0],
                    @rays[1].destination - @rays[0].destination,
                    Ray.new(@rays[1].destination, @rays[1].origin),
                    Ray.new(@rays[0].origin, Vector.new))
  end
end

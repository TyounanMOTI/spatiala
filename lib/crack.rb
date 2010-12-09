class Crack
  attr_accessor :line, :rays

  def initialize(line, *rays)
    @line = line
    @rays = rays.flatten
  end

  def sort!
    if (@rays[0].delta.cross(@rays[1].delta)).z < 0
      @rays.reverse!
    end
  end

  def to_beam
    beam = Beam.new(@rays[0].origin,
                    [
                     @rays[0].origin,
                     @rays[0].destination,
                     @rays[1].destination
                    ])
    beam.reference_segment = @line
    return beam
  end
end

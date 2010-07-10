class Beam
  attr_reader :origin, :deltas

  def initialize(origin, *deltas)
    @origin = origin
    @deltas = deltas
  end
end

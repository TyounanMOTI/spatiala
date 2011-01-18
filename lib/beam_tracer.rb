class BeamTracer
  attr_reader :geometry, :sources, :listener

  def initialize(geometry, sources, listener)
    @geometry = geometry
    @sources = sources
    @listener = listener
  end
end

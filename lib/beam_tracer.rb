class BeamTracer
  def initialize(geometry, sources, listener)
    @geometry = geometry
    @sources = sources
    @listener = listener
  end

  def intersect_with_no_walls?(ray)
    result = @geometry.lines.each do |wall|
      break false if ray.intersect?(wall)
    end
    return false unless result
    return true
  end
end

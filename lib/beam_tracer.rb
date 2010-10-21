class BeamTracer
  attr_reader :geometry, :sources, :listener

  def initialize(geometry, sources, listener)
    @geometry = geometry
    @sources = sources
    @listener = listener
  end


  def normalize(segment)
    normalizer = normalizer(segment)
    listener = @listener.transform(normalizer)
    if listener.position.x > 0
      listener.position = listener.position.transform(Matrix.reflector(Vector.new(1,0,0)))
    else
      normalizer = normalizer * Matrix.reflector(Vector.new(1,0,0))
    end
    geometry = @geometry.normalize(normalizer)
    sources = @sources.map { |i| i.transform(normalizer) }
    return BeamTracer.new(geometry, sources, listener)
  end

  def normalizer(segment)
    segment_center = (segment.origin + segment.destination)/2
    translator = Matrix.translator(-segment_center.x, -segment_center.y, -segment_center.z)
    translated_segment = segment.transform(translator)
    theta = Math.atan(translated_segment.origin.y.to_f / translated_segment.origin.x.to_f)
    rotator = Matrix.rotator(Math::PI/2 - theta)
    rotated_segment = translated_segment.transform(rotator)
    scaler = Matrix.scaler(1,1/rotated_segment.origin.y)
    return translator * rotator * scaler
  end
end

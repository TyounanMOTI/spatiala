class BeamTracer
  def initialize(geometry, sources, listener)
    @geometry = geometry
    @sources = sources
    @listener = listener
  end


  def get_split_ray_list
    list = Array.new
    @geometry.vertices.each do |vertex|
      ray = Ray.new(@listener.position, vertex)
      next unless intersect_with_no_walls?(ray)
      list.push ray
    end
    return list
  end

  def intersect_with_no_walls?(ray)
    result = @geometry.lines.each do |wall|
      break false if ray.intersect?(wall)
    end
    return false unless result
    return true
  end
end

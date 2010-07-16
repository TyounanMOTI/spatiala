class BeamTracer
  def initialize(geometry, sources, listener)
    @geometry = geometry
    @sources = sources
    @listener = listener
  end

  def make_crack_list
    crack_list = Array.new

    @geometry.vertices.each do |vertex|
      ray = Ray.new(@listener.position, vertex)
      next unless intersect_with_no_walls?(ray)
      @geometry.lines_include_vertex(vertex).each do |line|
        i = crack_list.index { |j| j.line == line }
        unless i then
          crack_list.push(Crack.new(line, ray))
        else
          crack_list[i].rays.push(ray)
        end
      end
    end
    return crack_list
  end

  def intersect_with_no_walls?(ray)
    result = @geometry.lines.each do |wall|
      break false if ray.intersect?(wall)
    end
    return false unless result
    return true
  end
end

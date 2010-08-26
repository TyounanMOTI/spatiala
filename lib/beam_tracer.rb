class BeamTracer
  def initialize(geometry, sources, listener)
    @geometry = geometry
    @sources = sources
    @listener = listener
  end

  def make_crack_list
    crack_list = connect_listener_to_vertices
    crack_list = extend_cracks crack_list

    return crack_list
  end

  def connect_listener_to_vertices
    list = CrackList.new
    @geometry.vertices.each do |vertex|
      ray = Ray.new(@listener.position, vertex)
      next unless intersect_with_no_walls?(ray)
      @geometry.lines_include_vertex(vertex).each do |line|
        list.append(Crack.new(line, ray))
      end
    end

    return list
  end

  def extend_cracks(list)
    list.each do |crack|
      crack.rays.each do |ray|
        @geometry.lines.each do |line|
          line_to_ray = line.intersect ray
          if line_to_ray > 0 && line_to_ray < 1 then
            ray_to_line = ray.intersect line
            if ray_to_line > 0 then
              new_ray = Ray.new(ray.origin, ray.origin + ray.delta*ray_to_line)
              list.append(Crack.new(line, new_ray))
            end
          end
        end
      end
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

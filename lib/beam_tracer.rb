class BeamTracer
  attr_reader :geometry, :sources, :listener

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

  def normalize(segment)
    normalizer = normalizer(segment)
    listener = normalize_listener(normalizer)
    if listener.position.x > 0
      listener.position = listener.position.transform(Matrix.reflector(Vector.new(1,0,0)))
    else
      normalizer = normalizer * Matrix.reflector(Vector.new(1,0,0))
    end
    geometry = normalize_geometry(normalizer)
    sources = normalize_sources(normalizer)
    return BeamTracer.new(geometry, sources, listener)
  end

  def normalize_listener(normalizer)
    return Listener.new(@listener.position.transform(normalizer),
                        @listener.direction.transform(normalizer))
  end

  def normalize_geometry(normalizer)
    polygons = @geometry.polygons.map { |i| i.transform(normalizer) }
    return Geometry.new(polygons)
  end

  def normalize_sources(normalizer)
    return @sources.map { |i| Source.new(i.position.transform(normalizer)) }
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

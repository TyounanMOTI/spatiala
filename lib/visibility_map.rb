class VisibilityMap
  attr_reader :regions, :geometry, :window, :normalized_geometry

  def initialize(geometry, window)
    @regions = geometry.lines.map do |i|
      # also dualize reversed ray, because non facing line will be nil when dualized
      [i.dualize, i.reverse.dualize]
    end.flatten.compact
    @geometry = geometry
    @window = window
    @normalized_geometry = @geometry.normalize(normalizer)
  end

  def normalizer
    window_center = (@window.origin + @window.destination)/2
    translator = Matrix.translator(-window_center.x, -window_center.y, -window_center.z)
    translated_window = @window.transform(translator)
    theta = Math.atan(translated_window.origin.y.to_f / translated_window.origin.x.to_f)
    rotator = Matrix.rotator(Math::PI/2 - theta)
    rotated_window = translated_window.transform(rotator)
    scaler = Matrix.scaler(1,1/rotated_window.origin.y)
    return translator * rotator * scaler
  end

  def get_intersection_points
    intersections = get_intersections
    rejected = reject_occluded_points(intersections)
    return IntersectionPoints.new(rejected.sort_by { |i| i.point.x })
  end

  def get_intersections
    vision = @tracer.listener.position.dualize
    points = @regions.map do |region|
      region.rays.map do |ray|
        ratio = vision.intersect(ray)
        next if ratio.nil?
        IntersectionPoint.new(ratio, region, @tracer.listener)
      end
    end.flatten.compact
    return IntersectionPoints.new(points)
  end

  def reject_occluded_points(intersection_points)
    intersection_points.reject { |i| @geometry.without_window.occlude?(i.dualize) }
  end

  class IntersectionPoints < Array
    def initialize(args)
      super
    end

    # TODO: we don't consider the case when we looks connection point of lines
    def make_pairs
      result = Array.new
      each_index do |i|
        current_point = self[i]
        next_point = self[i+1]
        result << current_point

        break if self[i+1].nil?
        unless current_point.region == next_point.region
          if current_point.region.include?(next_point)
            result << IntersectionPoint.new(next_point.ratio, current_point.region, next_point.listener)
          else
            result << IntersectionPoint.new(current_point.ratio, next_point.region, next_point.listener)
          end
        end
      end
      return IntersectionPoints.new(result.flatten)
    end
  end

  class IntersectionPoint < Vector
    attr_reader :ratio, :region, :listener

    def initialize(ratio, region, listener)
      @ratio = ratio
      @region = region
      @listener = listener
      super self.point.elements
    end

    def point
      (@listener.position.dualize * @ratio).destination
    end

    def dualize
      ray = Ray.new(@listener.position, Vector.new(0, @y)).fit(@region.original)
      ray.origin = Vector.new(0, @y)
      return ray
    end
  end
end

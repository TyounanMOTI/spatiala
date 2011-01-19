class VisibilityMap
  attr_reader :regions, :geometry, :window, :normalizer

  def initialize(geometry, window)
    @window = window
    @geometry = geometry.normalize(@window)
    @normalizer = geometry.normalizer(@window)
    @regions = @geometry.lines.map do |i|
      # also dualize reversed ray, because non facing line will be nil when dualized
      [i.dualize, i.reverse.dualize]
    end.flatten.compact
  end

  def intersection_points(listener_position)
    return IntersectionPoints.new(intersections_with_regions(listener_position).reject_occluded_by(@geometry).sort_by { |i| i.point.x })
  end

  def intersections_with_regions(listener_position)
    ray = listener_position.dualize
    points = @regions.map do |region|
      region.rays.map do |line|
        ratio = ray.intersect(line)
        next if ratio.nil?
        IntersectionPoint.new(ratio, region, listener_position)
      end
    end.flatten.compact
    return IntersectionPoints.new(points)
  end

  def normalize_listener_position(listener_position)
    return listener_position.transform(@normalizer * Matrix.reflector(Vector.new(1,0,0)))
  end

  class IntersectionPoints < Array
    def initialize(args)
      super
    end

    def reject_occluded_by(geometry)
      reject { |i| geometry.without_window.occlude?(i.dualize) }
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
    attr_reader :ratio, :region, :listener_position

    def initialize(ratio, region, listener_position)
      @ratio = ratio
      @region = region
      @listener_position = listener_position
      super self.point.elements
    end

    def point
      (@listener_position.dualize * @ratio).destination
    end

    def dualize
      ray = Ray.new(@listener_position, Vector.new(0, @y)).fit(@region.original)
      ray.origin = Vector.new(0, @y)
      return ray
    end
  end
end

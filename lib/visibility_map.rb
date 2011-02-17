class VisibilityMap
  attr_reader :regions, :geometry, :window, :normalizer

  def initialize(geometry, window)
    @window = window
    @geometry = geometry.normalize(@window)
    @normalizer = @window.normalizer
    @regions = @geometry.to_regions
  end

  def emit_beam(listener)
    intersection_points(listener.normalize(reflected_normalizer)).pack_same_ratios.make_pairs.to_beams(@geometry).transform(@normalizer.inverse)
  end

  def intersection_points(listener)
    return IntersectionPoints.new(intersections_with_regions(listener).reject_occluded_by(@geometry).sort)
  end

  def intersections_with_regions(listener)
    IntersectionPoints.by_ratio_originals(@regions.intersect(listener.dualize), listener)
  end

  def reflected_normalizer
    @normalizer*Matrix::Reflector[1,0,0]
  end

  class IntersectionPoints < Array
    def initialize(args=0)
      super
    end

    def self.by_ratio_originals(data, listener)
      IntersectionPoints.new(data.map { |i| IntersectionPoint.new(i[:ratio], listener, i[:original])})
    end

    def reject_occluded_by(geometry)
      reject { |i| geometry.without_window.occlude?(i.dualize) }
    end

    def pack_same_ratios
      sorted = self.sort_by { |i| i.ratio }
      result = IntersectionPoints.new
      each do |i|
        result << IntersectionPoint.new(i.ratio, i.listener) unless result.include?(i)
      end
      return result
    end

    def make_pairs
      result = IntersectionPoints.new
      each_index do |i|
        break if self[i+1].nil?
        result << IntersectionPoints.new([self[i], self[i+1]])
      end
      return result
    end

    def sort
      sort_by { |i| i.x }
    end

    def to_beams(geometry)
      array = map do |pair|
        center = IntersectionPoint.new((pair[0].ratio + pair[1].ratio)/2, pair[0].listener)
        target_ray = geometry.without_window.intersect(center.dualize).first.target_ray
        pair.each { |i| i.target_ray = target_ray }
        Ray.new(pair[0], pair[1]).dualize
      end
      return Beams.new(array)
    end
  end

  class IntersectionPoint < Vector
    attr_reader :ratio, :listener
    attr_accessor :target_ray

    def initialize(ratio, listener, target_ray=nil)
      @ratio = ratio
      @target_ray = target_ray
      @listener = listener
      super self.point.elements
    end

    def point
      (@listener.dualize * @ratio).destination
    end

    def dualize
      if @target_ray.nil?
        ray = Ray.new(@listener.position, Vector.new(0,@y))*Ray::BIG
        ray.origin = Vector.new(0,@y)
        return ray
      end

      ray = Ray.new(@listener.position, Vector.new(0, @y)).fit(@target_ray)
      ray.origin = Vector.new(0, @y)
      return ray
    end
  end
end

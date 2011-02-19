$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'vector'
require 'ray'
require 'polygon'
require 'geometry'
require 'beam'
require 'listener'
require 'source'
require 'beam_tracer'
require 'crack'
require 'crack_list'
require 'matrix'
require 'visibility_map'
require 'visibility_region'
require 'intersection'

RSpec.configure do |config|
  include Math
end

RSpec::Matchers.define :be_collection do |collection_class|
  match do |collection|
    collection.kind_of?(collection_class) && collection.reject {|i| i.kind_of?(@element_class)}
  end

  chain :of do |klass|
    @element_class = klass
  end
end

module Geometry::Environment
  def setup_geometry
    triangle = Polygon.new(Vector.new(10,20),
                           Vector.new(400,50),
                           Vector.new(30,420))
    wall = Polygon.new(Vector.new(100, 100),
                       Vector.new(250, 130))
    wall2 = Polygon.new(Vector.new(150, 90),
                        Vector.new(200, 100))

    @geometry = Geometry.new(triangle, wall, wall2)
  end
end

module BeamTracer::Environment
  include Geometry::Environment

  def setup_beam_tracer
    setup_geometry
    setup_listener
    setup_sources
  end

  def setup_listener
    @listener = Listener.new(Vector.new(100,200), Vector.new(30,30))
  end

  def setup_sources
    @sources = [Source.new(Vector.new(50,50))]
  end
end

module VisibilityRegion::Environment
  def setup_region
    original = Ray.new(Vector.new(0,0), Vector.new(0,0))
    vertices = [
            Vector.new(0,1),
            Vector.new(4,2),
            Vector.new(1,3),
           ]
    @region = VisibilityRegion.new(original, vertices)
  end
end

module VisibilityMap::Environment
  include BeamTracer::Environment

  IntersectionPoints = VisibilityMap::IntersectionPoints
  IntersectionPoint = VisibilityMap::IntersectionPoint

  def setup_visibility_map(window=1)
    setup_beam_tracer
    @window = @geometry.lines[window]
    @map = VisibilityMap.new(@geometry, @window)
    @normalized_listener = @listener.normalize(@map.reflected_normalizer)
  end
end

module VisibilityMap::IntersectionPoints::Environment
  include VisibilityMap::Environment

  def setup_intersection_points(window=1)
    setup_visibility_map(window)
    @intersection_points = @map.intersection_points(@normalized_listener)
  end
end

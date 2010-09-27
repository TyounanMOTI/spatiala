require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/beam_tracer_spec')

describe VisibilityMap do
  include BeamTracerEnvironment

  before do
    setup_beam_tracer
    @map = VisibilityMap.new(@tracer)
  end

  it "should be initialized with BeamTracer" do
    @map.should be_instance_of VisibilityMap
  end

  it "should have regions which is Array of VisibilityRegion" do
    @map.regions.should be_instance_of Array
    @map.regions.each { |i| i.should be_instance_of VisibilityRegion }
  end

  it "should return IntersectionPoints class when get_instersection_points" do
    @map.get_intersection_points.should be_instance_of IntersectionPoints
  end
end

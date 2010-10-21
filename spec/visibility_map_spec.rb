require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/beam_tracer_spec')
require File.expand_path(File.dirname(__FILE__) + '/visibility_region_spec')

describe VisibilityMap do
  include BeamTracer::Environment

  IntersectionPoints = VisibilityMap::IntersectionPoints
  IntersectionPoint = VisibilityMap::IntersectionPoint

  before do
    setup_beam_tracer
    @map = VisibilityMap.new(@tracer.normalize(@geometry.lines[0]))
  end

  it "should be initialized with BeamTracer" do
    @map.should be_instance_of VisibilityMap
  end

  it "should have regions which is Array of VisibilityRegion" do
    @map.regions.should be_instance_of Array
    @map.regions.each { |i| i.should be_instance_of VisibilityRegion }
  end

  it "should return Array of IntersectionPoint when get_intersections" do
    intersections = @map.get_intersections
    intersections.should_not be_empty
    intersections.should be_instance_of Array
    intersections.each { |i| i.should be_instance_of IntersectionPoint }
  end

  it "should return 4 IntersectionPoints when reject_occluded_points" do
    pending "until enumerate without WINDOW"
    rejected = @map.reject_occluded_points(IntersectionPoints.new(@map.get_intersections))
    rejected.length.should == 4
  end
end

describe VisibilityMap, "when get @intersection_points" do
  include BeamTracer::Environment

  IntersectionPoints = VisibilityMap::IntersectionPoints
  IntersectionPoint = VisibilityMap::IntersectionPoint

  before do
    setup_beam_tracer
    @map = VisibilityMap.new(@tracer.normalize(@geometry.lines[0]))
#    @intersection_points = @map.get_intersection_points
  end

  it "should return IntersectionPoints class when get_instersection_points" do
    pending "until correct get_intersection_points"
    @intersection_points.should be_instance_of IntersectionPoints
  end

  it "should return 4 IntersectionPoints when get_instersection_points" do
    pending "until correct get_intersection_points"
    @intersection_points.length.should == 4
  end

end

describe VisibilityMap::IntersectionPoints do
  IntersectionPoints = VisibilityMap::IntersectionPoints

  before do
    points = [
              Vector.new(-3,-3),
              Vector.new(-2,-2),
              Vector.new(-1,-1),
              Vector.new(0,0),
              Vector.new(1,1),
              Vector.new(2,2),
              Vector.new(3,3)
             ]
    @intersection_points = IntersectionPoints.new(points)
  end

  it "should be child of Array" do
    IntersectionPoints.superclass.should == Array
  end

  it "should generate instance of IntersectionPoints by including points" do
    @intersection_points.should be_instance_of IntersectionPoints
  end

  it "should return 7 when required length" do
    @intersection_points.length.should == 7
  end
end

describe VisibilityMap::IntersectionPoint do
  include VisibilityRegion::Environment
  include BeamTracer::Environment

  IntersectionPoint = VisibilityMap::IntersectionPoint

  before do
    setup_listener
    setup_region
    @intersection_point = IntersectionPoint.new(Vector.new(1,0), @region, @listener)
  end

  it "should initialize by point as Vector and region as VisibilityRegion" do
    @intersection_point.should be_instance_of IntersectionPoint
  end

  it "should have point, region and listener as member" do
    @intersection_point.point.should be_instance_of Vector
    @intersection_point.region.should be_instance_of VisibilityRegion
    @intersection_point.listener.should be_instance_of Listener
  end

  it "should return Ray when dualize" do
    @intersection_point.dualize.should be_instance_of Ray
  end
end

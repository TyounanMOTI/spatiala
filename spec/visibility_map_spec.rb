require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe VisibilityMap do
  include VisibilityMap::Environment

  before { setup_visibility_map }

  subject { @map }

  it "should be initialized with Geometry and window" do
    should be_instance_of VisibilityMap
  end

  describe "members" do
    its(:regions) { should be_collection(Array).of(VisibilityRegion) }
    its(:geometry) do
      should be_a Geometry
      subject.lines.should be_include Ray::WINDOW #should be normalized
    end
    its(:window) { should == @window }
    its(:normalizer) { should be_a Matrix }
  end

  describe "#normalize_listener_position" do
    subject { @map.normalize_listener_position(@listener.position) }
    it "should place listener to x < 0 region" do
      subject.x < 0
    end
  end

  context "acquired @normalized_listener_position" do
    before { @normalized_listener_position = @map.normalize_listener_position(@listener.position) }

    describe "#intersections_with_regions" do
      subject { @map.intersections_with_regions(@normalized_listener_position) }
      it { should be_collection(IntersectionPoints).of(IntersectionPoint) }
      its(:length) { should == 8 }
    end

    describe "#intersection_points" do
      subject { @map.intersection_points(@normalized_listener_position) }
      it { should be_collection(IntersectionPoints).of(IntersectionPoint) }
    end
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

describe VisibilityMap::IntersectionPoints, "which was built from VisilityMap" do
  include VisibilityMap::IntersectionPoints::Environment

  before do
    setup_intersection_points
  end

  describe "#reject_occluded_by" do
    before { @intersections = @map.intersections_with_regions(@normalized_listener_position) }
    subject { @intersections.reject_occluded_by(@map.geometry)}

    it { should be_collection(IntersectionPoints).of(IntersectionPoint) }
    its(:length) { should == 4 }
  end

  pending "#to_beams" do
    it "should return Array of Beam when converted to_beams" do
      beams = @intersection_points.to_beams
      beams.should be_instance_of Array
      beams.each { |i| i.should be_instance_of Beam }
    end

    it "should return 3 beams when converted to_beams" do
      @intersection_points.to_beams.length.should == 3
    end
  end
end

describe VisibilityMap::IntersectionPoint do
  include VisibilityRegion::Environment
  include BeamTracer::Environment

  IntersectionPoint = VisibilityMap::IntersectionPoint

  before do
    setup_listener
    setup_region
    @intersection_point = IntersectionPoint.new(0.5, @region.original, @listener.position)
  end

  it "should initialize by point as Vector and region as VisibilityRegion" do
    @intersection_point.should be_instance_of IntersectionPoint
  end

  describe "members" do
    subject { @intersection_point }
    its(:point) { should be_a Vector }
    its(:target_ray) { should be_a Ray }
    its(:listener_position) { should be_a Vector }
    its(:ratio) { should be_a Float }
  end

  it "should return Ray when dualize" do
    @intersection_point.dualize.should be_instance_of Ray
  end

  it "should child of Vector" do
    IntersectionPoint.superclass.should == Vector
  end

  it "should begins on Ray::WINDOW" do
    @intersection_point.dualize.origin.x = Ray::WINDOW.origin.x
  end
end

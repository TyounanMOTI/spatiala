require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/beam_tracer_spec')
require File.expand_path(File.dirname(__FILE__) + '/visibility_region_spec')

describe VisibilityMap do
  include BeamTracer::Environment

  IntersectionPoints = VisibilityMap::IntersectionPoints
  IntersectionPoint = VisibilityMap::IntersectionPoint

  before do
    setup_beam_tracer
    @window = @geometry.lines[1]
    @map = VisibilityMap.new(@geometry, @window)
  end

  subject { @map }

  it "should be initialized with Geometry and window" do
    should be_instance_of VisibilityMap
  end

  describe "members" do
    its(:regions) { should be_collection(Array).of(VisibilityRegion) }
    its(:geometry) { should be_a Geometry }
    its(:normalized_geometry) do
      should be_a Geometry
      subject.lines.should be_include Ray::WINDOW
    end
    its(:window) { should == @window }
  end

  pending "#get_intersections" do
    subject { @map.get_intersections }
    it { should be_collection(IntersectionPoints).of(IntersectionPoint) }
    its(:length) { should == 8 }
  end

  pending "#reject_occluded_points" do
    subject { @map.reject_occluded_points(@map.get_intersections) }
    it { should be_collection(IntersectionPoints).of(IntersectionPoint) }
    its(:length) { should == 4 }
  end
end

describe VisibilityMap, "which normalized by lines[3]" do
  pending "until adopt new initialization form" do
    include BeamTracer::Environment

    IntersectionPoints = VisibilityMap::IntersectionPoints
    IntersectionPoint = VisibilityMap::IntersectionPoint

    before do
      setup_beam_tracer
      @map = VisibilityMap.new(@tracer.normalize(@geometry.lines[3]))
    end

    it "should return 4 IntersectionPoints when get_intersection_points" do
      @map.get_intersection_points.length.should == 4
    end

    it "should return 4 points when get_intersections" do
      @map.get_intersections.length.should == 4
    end

    it "should have 2 regions in tracer" do
      @map.regions.length.should == 2
    end
  end
end

module VisibilityMap::IntersectionPoints::Environment
  include BeamTracer::Environment

  def setup_intersection_points(window=1)
    setup_beam_tracer
    @map = VisibilityMap.new(@tracer.normalize(@geometry.lines[window]))
    @intersection_points = @map.get_intersection_points
  end
end

describe VisibilityMap, "when get @intersection_points" do
  pending "until adopt new initialization form" do
    include VisibilityMap::IntersectionPoints::Environment

    IntersectionPoints = VisibilityMap::IntersectionPoints
    IntersectionPoint = VisibilityMap::IntersectionPoint

    before do
      setup_intersection_points
    end

    it "should return IntersectionPoints class when get_instersection_points" do
      @intersection_points.should be_instance_of IntersectionPoints
    end

    it "should return 4 IntersectionPoints when get_instersection_points" do
      @intersection_points.length.should == 4
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
  pending "until VisibilityMap adopts new initialization form" do
    include VisibilityMap::IntersectionPoints::Environment

    before do
      setup_intersection_points
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

    describe "#make_pairs" do
      it "should have 6 points when make_pairs" do
        paired = @intersection_points.make_pairs
        paired.length.should == 6
      end

      context "when window is 3rd line" do
        before { setup_intersection_points(3) }
        subject { @intersection_points.make_pairs }
        its(:length) { pending "until make_pairs corrected"; should == 4 }
      end
    end
  end
end

describe VisibilityMap::IntersectionPoint do
  pending "until VisibilityMap adopts new initialization form" do
    include VisibilityRegion::Environment
    include BeamTracer::Environment

    IntersectionPoint = VisibilityMap::IntersectionPoint

    before do
      setup_listener
      setup_region
      @intersection_point = IntersectionPoint.new(0.5, @region, @listener)
    end

    it "should initialize by point as Vector and region as VisibilityRegion" do
      @intersection_point.should be_instance_of IntersectionPoint
    end

    it "should have point, region and listener as member" do
      @intersection_point.point.should be_instance_of Vector
      @intersection_point.region.should be_instance_of VisibilityRegion
      @intersection_point.listener.should be_instance_of Listener
    end

    it "should have ratio as member" do
      @intersection_point.ratio.should be_instance_of Float
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
end

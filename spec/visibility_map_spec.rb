require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe VisibilityMap do
  include VisibilityMap::Environment

  before { setup_visibility_map }

  subject { @map }

  it "should be initialized with Geometry and window" do
    should be_instance_of VisibilityMap
  end

  describe "@geometry" do
    subject { @map.geometry }
    its(:lines) { should be_include Ray::WINDOW }#should be normalized
  end

  pending "acquired @normalized_listener" do
    describe "#intersections_with_regions" do
      subject { @map.intersections_with_regions(@normalized_listener) }
      it { should be_collection(IntersectionPoints).of(IntersectionPoint) }
      its(:length) { should == 8 }
    end

    describe "#intersection_points" do
      subject { @map.intersection_points(@normalized_listener) }
      it { should be_collection(IntersectionPoints).of(IntersectionPoint) }
    end
  end

  describe "#emit_beam" do
    subject { @map.emit_beam(@listener) }
    xit { should be_collection(Array).of(Beam) }
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

describe VisibilityMap::IntersectionPoints, "initialized by ratio and originals" do
  include BeamTracer::Environment

  before { setup_listener }
  describe "self.by_ratio_originals" do
    let(:ray) { Ray.new(Vector.new(0,0),Vector.new(10,10)) }
    let(:data) { [{:ratio => 1.0, :original => ray}] }
    subject { VisibilityMap::IntersectionPoints.by_ratio_originals(data, @listener) }
    its("first.ratio") { should == 1.0 }
  end
end

describe VisibilityMap::IntersectionPoints do
  pending "until adapt VisibilityRegion#intersect" do
    include VisibilityMap::IntersectionPoints::Environment

    before do
      setup_intersection_points
      @intersections = @map.intersections_with_regions(@normalized_listener)
      @rejected = @intersections.reject_occluded_by(@map.geometry)
      @packed = @rejected.pack_same_ratios
      @paired = @packed.make_pairs
    end

    describe "#reject_occluded_by" do
      subject { @intersections.reject_occluded_by(@map.geometry)}

      it { should be_collection(IntersectionPoints).of(IntersectionPoint) }
      its(:length) { should == 6 }
    end

    describe "#pack_same_ratios" do
      subject { @intersections.pack_same_ratios }

      it { should be_collection(IntersectionPoints).of(IntersectionPoint) }
      its(:length) { should < @intersections.length }
      specify { subject[4].target_ray.should be_nil }
    end

    describe "#make_pairs" do
      subject { @packed.make_pairs }

      it { should be_collection(IntersectionPoints).of(IntersectionPoints) }
      its(:length) { should == @packed.length - 1 }
    end

    describe "#to_beams" do
      subject { @paired.to_beams(@map.geometry) }
      it { should be_collection(Beams).of(Beam) }
      its(:length) { should == 4 }
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
    @intersection_point = IntersectionPoint.new(0.5, @listener.position, @region.original)
  end

  subject { @intersection_point }

  it "should child of Vector" do
    IntersectionPoint.superclass.should == Vector
  end

  describe "#dualize" do
    subject { @intersection_point.dualize }
    it { should be_a Ray }
    its("origin.x") { should == Ray::WINDOW.origin.x }

    context "when target_ray is nil" do
      subject { IntersectionPoint.new(0.5, @listener.position).dualize }
      its(:length) { should > Ray::BIG - 1 }
    end
  end
end

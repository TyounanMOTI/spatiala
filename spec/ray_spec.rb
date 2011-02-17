require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Ray do
  it "should generate instance" do
    Ray.new.should be_instance_of Ray
  end

  describe "#initialize with member" do
    subject { Ray.new(Vector.new(3,4), Vector.new(-6,0)) }
    its(:origin) { should == Vector.new(3,4) }
    its(:delta) { should == Vector.new(-9,-4) }
    its(:destination) { should == Vector.new(-6,0) }
  end

  context "when subject is Ray(1,0)->(2,4)" do
    let(:ray) { Ray.new(Vector.new(1,0), Vector.new(2,4)) }
    subject { ray }

    describe "#==" do
      it { should == Ray.new(Vector.new(1,0), Vector.new(2,4)) }
      it { should_not == Ray.new(Vector.new(0,1), Vector.new(5,6)) }
    end

    describe "#length" do
      specify { subject.length.should == subject.delta.length }
    end

    describe "#reverse" do
      its(:reverse) { should == Ray.new(Vector.new(2,4), Vector.new(1,0)) }
    end

    describe "#trim" do
      let(:range) { 0.1..0.5 }
      subject { ray.trim(range) }
      it { should == Ray.new(Vector.new(1.1,0.4), Vector.new(1.5,2.0))}

      context "range is 0.0..1.0" do
        subject { ray.trim(0.0..1.0) }
        it { should == ray }
      end
    end

    describe "#(member)=" do
      context "and changed its origin to (3,9)" do
        before { subject.origin = Vector.new(3,9) }
        its(:delta) { should == Vector.new(-1,-5) }
      end

      context "and changed its destination to (3,9)" do
        before { subject.destination = Vector.new(3,9) }
        its(:delta) { should == Vector.new(2,9) }
      end

      context "and changed its delta to (3,9)" do
        before { subject.delta = Vector.new(3,9) }
        its(:destination) { should == Vector.new(4,9) }
      end
    end

    context "and #transform by Matrix::Translator[2,2]" do
      before { @ray = subject.transform(Matrix::Translator[2,2]) }
      specify { @ray.should == Ray.new(Vector.new(3,2), Vector.new(4,6)) }
    end

    describe "#include?" do
      it { should be_include(Vector.new(1,0)) }
      it { should be_include(Vector.new(2,4)) }
      it { should be_include(Vector.new(1.5,2)) }
      it { should_not be_include(Vector.new(0,0)) }
      it { should_not be_include(Vector.new(1,2)) }
      it { should_not be_include(Vector.new(0,-4)) }
      it { should_not be_include(Vector.new(3,8)) }
    end

    describe "#maximize" do
      its("maximize.delta.length") { should >= Ray::BIG }
    end

    describe "#*(Fixnum) (expantion)" do
      specify { (subject*0.5).should == Ray.new(Vector.new(1,0),Vector.new(1.5,2)) }
    end

    describe "#normal" do
      its(:normal) { should be_a Vector }
    end
  end

  context "when @ray1 is Ray(-2,1)->(2,2), @ray2 is Ray(5,0)->(4,5)" do
    before do
      @ray1 = Ray.new(Vector.new(-2,1), Vector.new(2,2))
      @ray2 = Ray.new(Vector.new(5,0), Vector.new(4,5))
    end

    describe "#*(Ray) (dot product)" do
      specify { (@ray1*@ray2).should be_instance_of Float }
    end

    describe "#fit" do
      it "should return longer ray than @ray1 when @ray1.fit @ray2" do
        @ray1.fit(@ray2).length.should > @ray1.length
      end

      it "should return shorter ray than @ray2 when @ray2.fit @ray1" do
        @ray2.fit(@ray1).length.should < @ray2.length
      end
    end

    describe "#look_front" do
      it "should return @ray1 when @ray1.look_front" do
        @ray1.look_front.should == @ray1
      end

      it "should return reversed @ray2 when @ray2.look_front" do
        @ray2.look_front.should == @ray2.reverse
      end
    end
  end

  describe "#normalizer" do
    context "subject is Ray(-1,-1)->(1,1)" do
      subject { Ray.new(Vector.new(-1,-1), Vector.new(1,1)) }
      it "transforms subject to WINDOW" do
        subject.transform(subject.normalizer).should == Ray::WINDOW
      end

      it "return subject when transform and inverse transform" do
        subject.transform(subject.normalizer).transform(subject.normalizer.inverse).should == subject
      end
    end

    context "subject is Ray(1,1)->(-1,-1)" do
      subject { Ray.new(Vector.new(1,1), Vector.new(-1,-1)) }
      it "transforms subject to WINDOW" do
        subject.transform(subject.normalizer).should == Ray::WINDOW
      end
    end
  end

  describe "#facing (with WINDOW)" do
    specify { Ray.new(Vector.new(1,1), Vector.new(2,-3)).facing.should == :false }
    specify { Ray.new(Vector.new(2,0), Vector.new(3,0)).facing.should == :upper }
    specify { Ray.new(Vector.new(3,0), Vector.new(2,0)).facing.should == :lower }
    specify { Ray.new(Vector.new(2,-3), Vector.new(1,1)).facing.should == :true }
    specify { Ray.new(Vector.new(0,-1), Vector.new(10,0)).facing.should == :true }
    specify { Ray.new(Vector.new(10,0), Vector.new(0,-1)).facing.should == :false }
    specify { Ray.new(Vector.new(10,0), Vector.new(0,1)).facing.should == :true }
    specify { Ray.new(Vector.new(0,1), Vector.new(10,0)).facing.should == :false }
  end

  describe "#dualize" do
    it "should return VisibilityRegion when dualize" do
      Ray.new(Vector.new(1,0), Vector.new(2,4)).dualize.should be_instance_of VisibilityRegion
    end

    it "should have four Rays in VisibilityRegion when dualize Ray (3,-1) to (1,1)" do
      Ray.new(Vector.new(3,-1), Vector.new(1,1)).dualize.rays.length.should == 4
    end

    it "should return nil when dualize Ray which isn't facing with WINDOW" do
      Ray.new(Vector.new(1,1), Vector.new(3,-1)).dualize.should be_nil
    end

    it "should return nil when dualize Ray which is left of x-axis" do
      Ray.new(Vector.new(-1,1), Vector.new(-1,-1)).dualize.should be_nil
    end

    it "should include x == BIG Rays in VisibilityRegion when dualize Ray (2,3) to (-1,1)" do
      region = Ray.new(Vector.new(2,3), Vector.new(-1,1)).dualize
      far_point = Vector.new(Ray::BIG, 1)
      region.vertices.should include(far_point)
    end

    it "should include x == -BIG Rays in VisibilityRegion when dualize Ray (-1,-1) to (2,0)" do
      region = Ray.new(Vector.new(-1,-2), Vector.new(2,-2)).dualize
      far_point = Vector.new(-Ray::BIG, 1)
      region.vertices.should include(far_point)
    end

    it "should have three Rays in VisibilityRegion when dualize Ray (1,0) to (3,0)" do
      Ray.new(Vector.new(1,0), Vector.new(3,0)).dualize.rays.length.should == 3
    end

    it "should have Ray which is part of y=1 when dualize Ray (1,0) to (3,0)" do
      Ray.new(Vector.new(1,0), Vector.new(3,0)).dualize.rays[0].origin.y.should == 1
    end

    it "should have Ray which is part of y=-1 when dualize Ray (3,0) to (1,0)" do
      Ray.new(Vector.new(3,0), Vector.new(1,0)).dualize.rays[1].origin.y.should == -1
    end
  end

  describe "#intersect" do
    context "when @ray1 is Ray(0,1)->(1,2) and @ray2 is Ray(0,-1)->(1,-2)" do
      before do
        @ray1 = Ray.new(Vector.new(0,1), Vector.new(1,2))
        @ray2 = Ray.new(Vector.new(0,-1), Vector.new(1,-2))
      end

      specify { @ray1.intersect_as_directional_line(@ray2).should < 0 }
      specify { @ray1.intersect(@ray2).should be_nil }
    end

    it "should return a Float between 0 and 1 when intersect (0,1)->(1,-2) with (0,-1)->(1,2)" do
      ray1 = Ray.new(Vector.new(0,1), Vector.new(1,-2))
      ray2 = Ray.new(Vector.new(0,-1), Vector.new(1,2))
      result = ray1.intersect(ray2)
      result.should < 1
      result.should > 0
    end

    it "should return nil when intersect (0,1)->(1,2) with (3,1)->(1,5)" do
      ray1 = Ray.new(Vector.new(0,1), Vector.new(1,2))
      ray2 = Ray.new(Vector.new(3,1), Vector.new(1,5))
      ray1.intersect(ray2).should be_nil
    end
  end

  describe "#intersect?" do
    it "should true when Ray((1,0),(4,2)) intersect? ((0,1),(3,4))" do
      ray = Ray.new(Vector.new(0,1), Vector.new(4,2))
      wall = Ray.new(Vector.new(1,0), Vector.new(3,4))
      ray.should be_intersect(wall)
    end

    it "should true when (100,200)->(400,50) intersect? (100,100)->(250,130)" do
      ray = Ray.new(Vector.new(100,200), Vector.new(400,50))
      wall = Ray.new(Vector.new(100,100), Vector.new(250,130))
      ray.should be_intersect(wall)
    end
  end

  context "when extremes are given as VisibilityMap::IntersectionPoint" do
    include VisibilityMap::IntersectionPoints::Environment
    IntersectionPoint = VisibilityMap::IntersectionPoint

    before(:all) do
      setup_intersection_points
      @p = @intersection_points[0]
      @q = @intersection_points[1]
    end

    let(:ray) { Ray.new(@p, @q) }
    subject { ray }

    its(:origin) { should be_instance_of IntersectionPoint }
    its(:destination) { should be_instance_of IntersectionPoint }

    describe "#dualize" do
      subject { ray.dualize }

      it { should be_instance_of Beam }
      its("vertices.length") { should == 4 }
      its(:listener) { should == @q.listener }
      its(:target_ray) { should == @p.target_ray }
    end
  end
end

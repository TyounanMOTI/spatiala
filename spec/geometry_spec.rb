require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

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
    @listener = Vector.new(100,200)
  end
end

describe Geometry do
  include Geometry::Environment

  before do
    setup_geometry
    @view_ray = Ray.new(Vector.new(0,0), Vector.new(50,50))
  end

  subject { @geometry }

  it { should be_a Geometry }

  describe "members" do
    its(:polygons) { should be_collection(Array).of(Polygon) }
    its(:vertices) { should be_collection(Array).of(Vector) }
    its(:lines) { should be_collection(Array).of(Ray) }
  end

  describe "#lines_include" do
    it "should return Array of Ray" do
      lines = @geometry.lines_include(Vector.new(10, 20))
      lines.should be_collection(Array).of(Ray)
    end
  end

  describe "#nearest_intersect_line_with" do
    context "target_ray is Ray(0,0)->(50,50)" do
      subject { @geometry.nearest_intersect_line_with(@view_ray) }

      it { should be_instance_of Ray }
      it { should == Ray.new(Vector.new(10,20), Vector.new(400,50)) }
    end

    it "should return Ray(100,100)->(250,130) when get nearest_intersect_line_with Ray(100,200)->(400,50)" do
      @geometry.nearest_intersect_line_with(Ray.new(Vector.new(100,200), Vector.new(400,50))).should == Ray.new(Vector.new(100,100), Vector.new(250,130))
    end
  end

  describe "#ends_of_lines" do
    subject { @geometry.ends_of_lines }

    it "should return Array of Hash which key is :vertex, :line" do
      should be_instance_of Array
      subject.each do |i|
        i[:vertex].should be_instance_of Vector
        i[:line].should be_instance_of Ray
      end
    end

    it "should return double Vectors of lines" do
      subject.length.should == @geometry.lines.length*2
    end
  end

  describe "#occlude?" do
    it { should_not be_occlude(Ray.new(@listener, Vector.new(30,420))) }
    it { should be_occlude(Ray.new(@listener, Vector.new(150,90))) }

    it "should not occlude zero-length Ray" do
      should_not be_occlude(Ray.new(Vector.new(100,100), Vector.new(100,100)))
    end
  end

  describe "#intersect" do
    subject { @geometry.intersect(Ray.new(@listener, Vector.new(100,100)).maximize) }
    it { should be_a Intersections }
    its(:length) { should == 2 }
  end
end

describe Geometry, "which normalized" do
  pending "until VisibilityMap#normalize moves to Geometry" do
    include Geometry::Environment

    before do
      setup_geometry
      @tracer = BeamTracer.new(@geometry, nil, nil)
      @normalizer = @tracer.normalizer(@geometry.lines[0])
      @geometry = @geometry.normalize(@normalizer)
    end

    subject { @geometry }

    it { should be_a Geometry }
    its(:lines) { should include Ray::WINDOW }
    its("without_window.lines") { should_not include Ray::WINDOW }
  end
end

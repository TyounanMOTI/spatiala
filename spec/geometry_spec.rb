require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Geometry do
  before do
    setup_geometry
    setup_listener
    @view_ray = Ray.new(Vector.new(0,0), Vector.new(50,50))
  end
  let(:listener) { @listener }
  let(:geometry) { @geometry }

  subject { @geometry }

  it { should be_a Geometry }

  describe "members" do
    its(:polygons) { should be_collection(Array).of(Polygon) }
    its(:vertices) { should be_collection(Array).of(Vector) }
    its(:lines) { should be_collection(Array).of(Ray) }
  end

  describe "#generate_beam_tree" do
    it "returns BeamTree" do
      tree = double("beam tree")
      subject.should_receive(:pencil_shape_split).with(listener) { tree }.ordered.once
      tree.should_receive(:traverse) { tree }.ordered.once
      subject.generate_beam_tree(listener)
    end
  end

  describe "#pencil_shape_split" do
    it "returns BeamTree which includes Beams" do
      rays = double
      subject.should_receive(:connect_listener_vertices).with(listener) { rays }
      subject.should_receive(:reject_occluded_rays) { rays }
      subject.should_receive(:extend_rays) { rays }
      rays.should_receive(:to_beams) { [:beam] }
      subject.pencil_shape_split(listener).children.should include :beam
    end
  end

  describe "#connect_listener_vertices" do
    subject { geometry.connect_listener_vertices(listener) }

    it { should be_a IntersectionRays }
    it "sends :append to IntersectionRays at least once" do
      rays = double("intersection rays")
      IntersectionRays.should_receive(:new) { rays }
      rays.should_receive(:append).at_least(:once)
      subject
    end
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
    it { should_not be_occlude(Ray.new(@listener.position, Vector.new(30,420))) }
    it { should be_occlude(Ray.new(@listener.position, Vector.new(150,90))) }

    it "should not occlude zero-length Ray" do
      should_not be_occlude(Ray.new(Vector.new(100,100), Vector.new(100,100)))
    end
  end

  describe "#intersect" do
    subject { @geometry.intersect(Ray.new(@listener.position, Vector.new(100,100)).maximize) }
    it { should be_a Intersections }
    its(:length) { should == 2 }
  end

  describe "#transform when translate (1,1,0)" do
    subject { @geometry.transform(Matrix::Translator[1,1,0]) }
    it { should be_a Geometry }
    it "should translate vertex[0]" do
      subject.vertices[0].should == @geometry.vertices[0] + Vector.new(1,1,0)
    end
  end
end

describe Geometry, "which normalized" do
  before do
    setup_geometry
    @window = @geometry.lines[0]
  end

  subject { @geometry.normalize(@window) }

  it { should be_a Geometry }

  describe "#normalize" do
    its(:lines) { should include Ray::WINDOW }
  end

  describe "#without_window" do
    its("without_window.lines") { should_not include Ray::WINDOW }
  end

  describe "#to_regions" do
    subject { @geometry.to_regions }
    it { should be_collection(VisibilityRegions).of(VisibilityRegion) }
  end
end

describe Geometry::IntersectionRays do
  subject { IntersectionRays.new }

  describe "#length" do
    before { subject.rays = { :a => [1,2], :b => [1,2], :c => [1,2] } }
    its(:length) { should == 6 }
  end
end


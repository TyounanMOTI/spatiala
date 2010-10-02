require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/beam_tracer_spec')

describe CrackList, "when initialize with Array of Crack" do
  before do
    @line1 = Ray.new(Vector.new(1,0), Vector.new(10,20))
    @line2 = Ray.new(Vector.new(2,0), Vector.new(30,40))
    @ray1 = Ray.new(Vector.new(4,20), Vector.new(1,0))
    @ray2 = Ray.new(Vector.new(30,2), Vector.new(3,5))
    @crack1 = Crack.new(@line1, @ray1, @ray2)
    @crack2 = Crack.new(@line2, @ray2, @ray1)
    @crack3 = Crack.new(@line1, @ray2, @ray1)
    @crack4 = Crack.new(@line1, @ray1, @ray2)
    @list = CrackList.new(@crack1)
  end

  it "should initialize with Cracks" do
    @list.should be_instance_of CrackList
  end

  it "should have cracks" do
    @list.should be_instance_of CrackList
    @list.each { |i| i.should be_instance_of Crack }
  end

  it "should append new crack to list when there are'nt already exist crack which have same line" do
    previous_length = @list.length
    @list.append @crack2
    @list.length.should == previous_length + 1
  end

  it "should append to existing crack when there are already exist crack which have same line" do
    @list.append @crack4
    previous_length = @list.length
    @list.append @crack3
    @list.length.should == previous_length
  end

  it "should get Crack when get crack_list element by index" do
    @list[0].should be_instance_of Crack
  end

  it "should get Array of Beam when to_beams" do
    @list.to_beams.should be_instance_of Array
    @list.to_beams.each { |i| i.should be_instance_of Beam }
  end

  it "should get Beams same length of Cracks when to_beams" do
    @list.to_beams.length.should == @list.length
  end
end

describe CrackList, "when initialize from Geometry and Listener" do
  include BeamTracerEnvironment

  before do
    setup_geometry
    setup_listener
    @list = CrackList.new(@geometry, @listener)
    @connected_rays = @list.connect_listener_and_vertices
#    @rejected_rays = @list.reject_occluded(@connected_rays)
#    @expanded_rays = @list.expand(@rejected_rays)
  end

  it "should return CrackList when initialized" do
    @list.should be_instance_of CrackList
  end

  it "should return Intersections when connect_listener_and_vertices" do
    @connected_rays.should be_instance_of Intersections
  end

  it "should return 4 less Rays when reject_occluded_rays" do
    pending "until it adapts Array"
    @rejected_rays.to_rays.length.should == @connected_rays.to_rays.length - 4
  end

  it "should return 2 more Rays when expand rays" do
    pending "until it adapts Array"
    pending "until Geometry.intersect returns by Intersections"
    @expanded_rays.length.should == @rejected_rays.length + 2
  end
end

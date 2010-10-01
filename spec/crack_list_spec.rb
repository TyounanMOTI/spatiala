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
#    @connected_rays = @list.connect_listener_and_vertices
#    @rejected_rays = @list.reject_occluded_rays(@connected_rays)
#    @expanded_rays = @list.expand(@rejected_rays)
  end

  it "should return CrackList when initialized" do
    @list.should be_instance_of CrackList
  end

  it "should return Intersections when connect_listener_and_vertices" do
    pending "during convert Hash to Intersection[s]"
    @connected_rays.should be_instance_of Intersections
  end

  it "should return 4 less Rays when reject_occluded_rays" do
    pending "during convert Hash to Intersection[s]"
    @list.ratios_to_rays(@rejected_rays).length.should == @list.ratios_to_rays(@connected_rays).length - 4
  end

  it "should return 2 more Rays when expand rays" do
    pending "during convert Hash to Intersection[s]"
    @expanded_rays.length.should == @rejected_rays.length + 2
  end
end

module CrackList::IntersectionEnvironment
  def setup_intersection
    @target_ray = Ray.new(Vector.new(10,20), Vector.new(400,50))
    @ratios = [0.0, 0.3, 1.0]
    @intersection = CrackList::Intersection.new(@target_ray, @ratios)
  end
end

describe CrackList::Intersection do
  include BeamTracerEnvironment
  include CrackList::IntersectionEnvironment

  before do
    setup_listener
    setup_intersection
  end

  it "should initialized by its target_ray and ratios" do
    @intersection.should be_instance_of CrackList::Intersection
  end

  it "should have members target_ray and ratios" do
    @intersection.target_ray.should be_instance_of Ray
    @intersection.ratios.should be_instance_of Array
    @intersection.ratios.each { |i| i.should be_instance_of Float }
  end

  it "should return Array of Ray when convert to_rays" do
    rays = @intersection.to_ray(@listener)
    rays.should be_instance_of Array
    rays.each { |i| i.should be_instance_of Ray }
  end
end

describe CrackList::Intersections do
  include CrackList::IntersectionEnvironment
  include BeamTracerEnvironment

  before do
    setup_listener
    setup_intersection
    @intersections = CrackList::Intersections.new([@intersection] * 5)
  end

  it "should initialized by Array of Intersection" do
    @intersections.should be_instance_of CrackList::Intersections
  end

  it "should have Array of Intersection" do
    @intersections.intersections.should be_instance_of Array
    @intersections.intersections.each { |i| i.should be_instance_of CrackList::Intersection }
  end

  it "should have includes Enumerable" do
    CrackList::Intersections.should be_include Enumerable
  end

  it "should be able to use 'each'" do
    @intersections.each { |i| i.should be_instance_of CrackList::Intersection }
  end

  it "should return Array of Ray when convert to_ray" do
    @intersections.to_ray(@listener).should be_instance_of Array
    @intersections.to_ray(@listener).each { |i| i.should be_instance_of Ray }
  end
end

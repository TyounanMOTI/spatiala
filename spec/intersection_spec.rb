require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/beam_tracer_spec')

module IntersectionEnvironment
  include BeamTracerEnvironment

  def setup_intersection
    setup_listener
    @target_ray = Ray.new(Vector.new(10,20), Vector.new(400,50))
    @ratios = [0.0, 0.3, 1.0]
    @intersection = Intersection.new(@listener.position, @target_ray, @ratios)
  end
end

describe Intersection do
  include IntersectionEnvironment

  before do
    setup_intersection
  end

  it "should initialized by its origin, target_ray and ratios" do
    @intersection.should be_instance_of Intersection
  end

  it "should have members origin, target_ray and ratios" do
    @intersection.origin.should be_instance_of Vector
    @intersection.target_ray.should be_instance_of Ray
    @intersection.ratios.should be_instance_of Array
    @intersection.ratios.each { |i| i.should be_instance_of Float }
  end

  it "should return Array of Ray when convert to_rays" do
    rays = @intersection.to_rays
    rays.should be_instance_of Array
    rays.each { |i| i.should be_instance_of Ray }
  end

  it "should not have equal ratios, origin and target_ray when duplicated" do
    @intersection.dup.ratios.should_not be_equal @intersection.ratios
    @intersection.dup.origin.should_not be_equal @intersection.origin
    @intersection.dup.target_ray.should_not be_equal @intersection.target_ray
  end
end

describe Intersections do
  include IntersectionEnvironment

  before do
    setup_intersection
    @intersections = Intersections.new(5, @intersection)
    @ray = Ray.new(Vector.new(400,50), Vector.new(30,420))
    intersection2 = Intersection.new(@listener.position, @ray, [0.7])
    @intersections2 = Intersections.new([intersection2])
    @merged = @intersections.merge(@intersections2)
  end

  it "should superclass of Array" do
    Intersections.superclass.should == Array
  end

  it "should initialized by Array of Intersection" do
    @intersections.should be_instance_of Intersections
  end

  it "should have Array of Intersection" do
    @intersections.each { |i| i.should be_instance_of Intersection }
  end

  it "should have includes Enumerable" do
    Intersections.should be_include Enumerable
  end

  it "should be able to use 'each'" do
    @intersections.each { |i| i.should be_instance_of Intersection }
  end

  it "should return Array of Ray when convert to_rays" do
    @intersections.to_rays.should be_instance_of Array
    @intersections.to_rays.each { |i| i.should be_instance_of Ray }
  end

  it "length should be 5" do
    @intersections.length.should == 5
  end

  it "should return Intersections when merged" do
    @merged.should be_instance_of Intersections
  end

  it "should have record of Ray(400,50)->(30,420) when merged @intersections2" do
    @merged.index { |i| i.target_ray == @ray }.should_not be_nil
  end

  it "should have ratio 0.9 on record of Ray(400,50)->(30,420) when merged that on @merged" do
    intersection = Intersection.new(@listener.position, @ray, [0.9])
    intersections = Intersections.new([intersection])
    result = @merged.merge(intersections)
    index = result.index { |i| i.target_ray == @ray }
    result[index].ratios.should be_include 0.9
  end

  it "should return Intersections when duplicated" do
    @intersections.dup.should be_instance_of Intersections
  end

  it "should deep-copy when duplicated" do
    duplicated = @intersections.dup
    duplicated.each_index { |i| @intersections[i].should_not be_equal duplicated[i] }
  end
end


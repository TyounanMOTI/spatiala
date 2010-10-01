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
end

describe Intersections do
  include IntersectionEnvironment

  before do
    setup_intersection
    @intersections = Intersections.new([@intersection] * 5)
  end

  it "should initialized by Array of Intersection" do
    @intersections.should be_instance_of Intersections
  end

  it "should have Array of Intersection" do
    @intersections.intersections.should be_instance_of Array
    @intersections.intersections.each { |i| i.should be_instance_of Intersection }
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
end

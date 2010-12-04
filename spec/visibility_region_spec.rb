require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module VisibilityRegion::Environment
  def setup_region
    original = Ray.new(Vector.new(0,0), Vector.new(0,0))
    rays = [
            Ray.new(Vector.new(0,1), Vector.new(4,2)),
            Ray.new(Vector.new(4,2), Vector.new(1,3)),
            Ray.new(Vector.new(1,3), Vector.new(0,1))
           ]
    @region = VisibilityRegion.new(original, rays)
  end
end

describe VisibilityRegion do
  include VisibilityRegion::Environment

  before do
    setup_region
  end

  it "should be initialized with Rays" do
    @region.should be_instance_of VisibilityRegion
  end

  it "should have boundary rays" do
    @region.rays.should be_instance_of Array
    @region.rays.each { |i| i.should be_instance_of Ray }
  end

  it "should return Array of Vector when requested its vertices" do
    @region.vertices.should be_instance_of Array
    @region.vertices.length.should > 0
    @region.vertices.each { |i| i.should be_instance_of Vector }
  end

  it "should not have same vertex at vertices" do
    @region.vertices.length.should == 3
  end

  it "should return true when ==ed regions which original and rays are same" do
    original = Ray.new(Vector.new(0,0), Vector.new(0,0))
    rays = [
            Ray.new(Vector.new(0,1), Vector.new(4,2)),
            Ray.new(Vector.new(4,2), Vector.new(1,3)),
            Ray.new(Vector.new(1,3), Vector.new(0,1))
           ]
    region2 = VisibilityRegion.new(original, rays)
    (@region == region2).should == true
  end

  it "should return false when ==ed regions which original and rays are differ" do
    original = Ray.new(Vector.new(0,0), Vector.new(0,0))
    rays = [
            Ray.new(Vector.new(0,1), Vector.new(4,2)),
            Ray.new(Vector.new(4,2), Vector.new(1,3)),
            Ray.new(Vector.new(0,0), Vector.new(0,6))
           ]
    region2 = VisibilityRegion.new(original, rays)
    (@region == region2).should == false
  end
end

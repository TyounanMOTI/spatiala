require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe VisibilityRegion do
  include VisibilityRegion::Environment

  before do
    setup_region
  end

  it "should be child of Polygon" do
    VisibilityRegion.superclass == Polygon
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
    vertices = [
            Vector.new(0,1),
            Vector.new(4,2),
            Vector.new(1,3),
           ]
    region2 = VisibilityRegion.new(original, vertices)
    (@region == region2).should == true
  end

  it "should return false when ==ed regions which original and rays are differ" do
    original = Ray.new(Vector.new(0,0), Vector.new(0,0))
    vertices = [
            Vector.new(0,1),
            Vector.new(4,2),
            Vector.new(0,0),
           ]
    region2 = VisibilityRegion.new(original, vertices)
    (@region == region2).should == false
  end
end

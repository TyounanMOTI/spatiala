require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe VisibilityRegion do
  before do
    original = Ray.new(Vector.new(0,0), Vector.new(0,0))
    @ray = Ray.new(Vector.new(0,1), Vector.new(4,2))
    @region = VisibilityRegion.new(original, @ray)
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
end

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe VisibilityRegion do
  before do
    @ray = Ray.new(Vector.new(0,1), Vector.new(4,2))
    @region = VisibilityRegion.new(@ray)
  end

  it "should be initialized with a Ray" do
    @region.should be_instance_of VisibilityRegion
  end
end

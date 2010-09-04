require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe VisibilityRegion do
  it "should generate instance of VisibilityRegion when initialize" do
    VisibilityRegion.new.should be_instance_of VisibilityRegion
  end
end

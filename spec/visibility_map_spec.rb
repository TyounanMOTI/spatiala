require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe VisibilityMap do
  it "should return instance of VisibilityMap when initialize" do
    VisibilityMap.new.should be_instance_of VisibilityMap
  end
end

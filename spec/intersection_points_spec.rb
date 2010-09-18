require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe IntersectionPoints do
  it "should generate instance of IntersectionPoints" do
    IntersectionPoints.new.should be_instance_of IntersectionPoints
  end
end

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Geometry do
  it "should generate instance" do
    Geometry.new.should be_instance_of Geometry
  end
end

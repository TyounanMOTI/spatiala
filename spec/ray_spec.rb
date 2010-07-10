require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Ray do
  it "should generate instance" do
    Ray.new.should be_instance_of Ray
  end
end

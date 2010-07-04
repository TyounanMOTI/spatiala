require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Vector do
  it "returns Vector if initialize with no arguments" do
    vector = Vector.new()
    vector.should be_instance_of Vector
  end
end

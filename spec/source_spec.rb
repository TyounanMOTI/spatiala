require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Source do
  it "should be initialized with its position" do
    Source.new(Vector.new(300,50)).should be_instance_of Source
  end
end

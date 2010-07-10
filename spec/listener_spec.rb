require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Listener do
  it "should be initialized with position, direction" do
    Listener.new(Vector.new(10,10), Vector.new(40,50).normalize).should be_instance_of Listener
  end
end

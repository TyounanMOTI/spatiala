require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Listener do
  before do
    @listener = Listener.new(Vector.new(10,10), Vector.new(40,50).normalize)
  end

  it "should be initialized with position, direction" do
    @listener.should be_instance_of Listener
  end

  it "should have position, direction" do
    @listener.position.should == Vector.new(10,10)
    @listener.direction.should == Vector.new(40,50).normalize
  end

  it "should have children array" do
    @listener.children.should be_instance_of Array
  end

  it "should return Listener when transformed" do
    @listener.transform(Matrix.translator(2,3)).should be_instance_of Listener
  end
end


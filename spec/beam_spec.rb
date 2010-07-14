require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Beam do
  before do
    @beam = Beam.new(Vector.new(50,100),
                     Vector.new(400,40),
                     Vector.new(30,300))
  end

  it "should generate instance" do
    @beam.should be_instance_of Beam
  end

  it "should have Vectors: origin, deltas" do
    @beam.origin.should == Vector.new(50,100)
    @beam.deltas[0].should == Vector.new(400,40)
    @beam.deltas[1].should == Vector.new(30,300)
  end

  it "should have children array" do
    @beam.children.should be_instance_of Array
  end
end

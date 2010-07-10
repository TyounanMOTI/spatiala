require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Geometry do
  it "should generate instance" do
    Geometry.new.should be_instance_of Geometry
  end

  it "should 3 lines in triangle" do
    geometry = Geometry.new(Vector.new(10,20),
                            Vector.new(400,50),
                            Vector.new(30,420))
    geometry.lines.length.should == 3
    geometry.lines[0].should be_instance_of Ray
  end
end

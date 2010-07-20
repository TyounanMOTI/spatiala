require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Polygon do
  it "should generate instance" do
    Polygon.new.should be_instance_of Polygon
  end

  it "should 3 lines in triangle" do
    polygon = Polygon.new(Vector.new(10,20),
                          Vector.new(400,50),
                          Vector.new(30,420))
    polygon.lines.length.should == 3
    polygon.lines[0].should be_instance_of Ray
  end

  it "should a line in 2 point polygon" do
    polygon = Polygon.new(Vector.new(3,10),
                          Vector.new(5,8))
    polygon.lines.length.should == 1
    polygon.lines[0].should be_instance_of Ray
  end
end

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Polygon do
  it "should generate instance" do
    Polygon.new.should be_instance_of Polygon
  end

  it "should a line in 2 point polygon" do
    polygon = Polygon.new(Vector.new(3,10),
                          Vector.new(5,8))
    polygon.lines.length.should == 1
    polygon.lines[0].should be_instance_of Ray
  end

  it "should transform each vertices when translator is (2,-1,0)" do
    polygon = Polygon.new(Vector.new(3,10),
                          Vector.new(5,8))
    polygon.transform(Matrix.translator(2,-1,0)).vertices.should ==
      [Vector.new(5,9), Vector.new(7,7)]
  end

  it "should 3 lines in triangle" do
    polygon = Polygon.new(Vector.new(10,20),
                           Vector.new(400,50),
                           Vector.new(30,420))
    polygon.lines.length.should == 3
    polygon.lines[0].should be_instance_of Ray
  end
end

describe Polygon, "which is triangle disabled 0, 1" do
  before do
    @polygon = Polygon.new(Vector.new(10,20),
                           Vector.new(400,50),
                           Vector.new(30,420))
    @polygon.disable!(Ray.new(@polygon.vertices[0], @polygon.vertices[1]))
  end

  it "should have 1 element on @disabled" do
    @polygon.disabled.length.should == 1
  end

  it "should return true when 0,1 disabled?" do
    @polygon.disabled?(0,1).should == true
  end

  it "should return false when 0,2 disabled?" do
    @polygon.disabled?(0,2).should == false
  end

  it "should return 2 lines" do
    @polygon.lines.length.should == 2
  end
end

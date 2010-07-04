require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Vector do
  it "should returns Vector when initialize with no arguments" do
    vector = Vector.new()
    vector.should be_instance_of Vector
  end

  it "should returns (3,-1,5,1) Vector when initialize with Vector.new(3,-1,5)" do
    vector = Vector.new(3, -1, 5)
    vector.x.should == 3
    vector.y.should == -1
    vector.z.should == 5
    vector.w.should == 1
  end

  it "returns 44 when dot product (3,-1,5) with (-2,0,10)" do
    v1 = Vector.new(3,-1,5)
    v2 = Vector.new(-2,0,10)
    result = v1 * v2
    result.should == 44
  end

  it "returns when cross product (3,-1,5) with (-2,3,10)" do
    v1 = Vector.new(3,-1,5)
    v2 = Vector.new(-2,3,10)
    result = v1.cross(v2)
    result.x.should == -25
    result.y.should == -40
    result.z.should == 7
    result.w.should == 1
  end

end

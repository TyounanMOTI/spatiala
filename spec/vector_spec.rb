require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Vector do
  before do
    @v1 = Vector.new(3,-1,5)
    @v2 = Vector.new(-2,3,10)
  end

  it "should returns Vector when initialize with no arguments" do
    vector = Vector.new()
    vector.should be_instance_of Vector
  end

  it "should returns (3,-1,5,1) Vector when initialize with Vector.new(3,-1,5)" do
    @v1.x.should == 3
    @v1.y.should == -1
    @v1.z.should == 5
    @v1.w.should == 1
  end

  it "returns 44 when dot product (3,-1,5) with (-2,0,10)" do
    v2 = Vector.new(-2,0,10)
    result = @v1 * v2
    result.should == 44
  end

  it "returns when cross product (3,-1,5) with (-2,3,10)" do
    result = @v1.cross(@v2)
    result.x.should == -25
    result.y.should == -40
    result.z.should == 7
    result.w.should == 1
  end

  it "returns (1,2,15) when add (3,-1,5) with (-2,3,10)" do
    result = @v1 + @v2
    result.x.should == 1
    result.y.should == 2
    result.z.should == 15
    result.w.should == 1
  end

end

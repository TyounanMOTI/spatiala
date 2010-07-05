require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Vector, "with v1(3,-1,5), v2(-2,3,10)" do
  before do
    @v1 = Vector.new(3,-1,5)
    @v2 = Vector.new(-2,3,10)
  end

  it "should returns Vector when initialize with no arguments" do
    vector = Vector.new()
    vector.should be_instance_of Vector
  end

  it "should returns (3,-1,5,1) Vector when initialize with Vector.new(3,-1,5)" do
    @v1.should == Vector.new(3,-1,5)
  end

  it "returns 44 when dot product v1 with (-2,0,10)" do
    v2 = Vector.new(-2,0,10)
    result = @v1 * v2
    result.should == 44
  end

  it "returns (-25,-40,7) when cross product v1 with v2" do
    result = @v1.cross(@v2)
    result.should == Vector.new(-25,-40,7)
  end

  it "returns (1,2,15) when add v1 with v2" do
    result = @v1 + @v2
    result.should == Vector.new(1,2,15)
  end

  it "returns true when those vectors are same" do
    @v1.should == Vector.new(3,-1,5)
  end

  it "returns false when those vectors are differ" do
    @v1.should_not == Vector.new(3,0,5)
  end

  it "returns (5,-4,-5) when v1 minus v2" do
    result = @v1 - @v2
    result.should == Vector.new(5, -4, -5)
  end

  it "returns (-3,1,-5) when minus v1" do
    result = -@v1
    result.should == Vector.new(-3,1,-5)
  end

  it "returns (1.5,-0.5,2.5) when v1 / 2" do
    result = @v1 / 2.0
    result.should == Vector.new(1.5,-0.5,2.5)
  end
end
# v1(3,-1,5) v2(-2,3,10)

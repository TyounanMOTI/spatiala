require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Vector do
  before do
    @v1 = Vector.new(3,-1,5)
    @v2 = Vector.new(-2,3,10)
  end

  it "should return 3 when v1.x" do
    @v1.x.should == 3
  end

  it "should return 0 when v1.w" do
    @v1.w.should == 0
  end

  it "should have 4 elements in v1" do
    @v1.elements.length.should == 4
  end

  it "should have its x value at @v1[0]" do
    @v1[0].should == @v1.x
  end

  it "should be writable its elements by index" do
    vector = Vector.new(1,2,3)
    vector[0] = 2
    vector.x.should == 2
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

  it "should return true when vectors are almost same" do
    Vector.new(0,1).should == Vector.new(0,1.00000001)
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

  it "returns (6,-2,10) when v1 * 2" do
    result = @v1 * 2
    result.should == Vector.new(6,-2,10)
  end

  it "returns length 5.x when measured length of v1" do
    result = @v1.length
    result.should < 6
    result.should > 5
  end

  it "should normalize v1" do
    result = @v1.normalize
    result.length.should > 0.9
    result.length.should < 1.1
  end

  it "should be Enumerable" do
    result = 0
    @v1.each { |i| result += i }
    result.should == 7
  end

  it "should transform v1 to v2 with Matrix.translator(-5,4,5)" do
    @v1.transform(Matrix.translator(-5,4,5)).should == @v2
  end

  it "should return Ray (0,1) to (2,-1) when dualize Vector (1,1)" do
    v = Vector.new(1,1)
    ray = v.dualize
    ray.should == Ray.new(Vector.new(0,1), Vector.new(2,-1))
  end

  it "should return Vector (0,5) when snap (1.0e-15, 5)" do
    Vector.new(1.0e-15, 5).snap.should == Vector.new(0,5)
  end

  it "should return Vector (0,5) when snap (-1.0e-15, 5)" do
    Vector.new(-1.0e-15, 5).snap.should == Vector.new(0,5)
  end

  it "should return Vector (4,-1) when snap (4, -1 + 1.0e-15)" do
    Vector.new(4, -1 + 1.0e-15).snap.should == Vector.new(4,-1)
  end

  it "should return same hash when their elements are same" do
    Vector.new(1,2).hash.should == Vector.new(1,2).hash
  end

  it "should return eql when their elements are same" do
    Vector.new(1,2).eql?(Vector.new(1,2)).should == true
  end
end
# v1(3,-1,5) v2(-2,3,10)

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Matrix do
  before do
    @m1 = Matrix.new(Vector.new(-2, -1,  0, 0),
                     Vector.new( 1,  2,  3, 0),
                     Vector.new( 1,  0, -1, 0),
                     Vector.new( 4,  2,  1, 1))

    @m2 = Matrix.new(Vector.new( 3,  4,  1, 0),
                     Vector.new(-2,  0,  3, 0),
                     Vector.new( 4, -1,  3, 0),
                     Vector.new(-1,  1,  3, 1))
  end

  it "should initialize with 4*3 vectors" do
    @m1.should be_instance_of Matrix
  end

  it "should have row vector" do
    @m1.row(1).should == Vector.new(1, 2, 3, 0)
  end

  it "should have column vector" do
    @m1.column(1).should == Vector.new(-1, 2, 0, 2)
  end

  it "should return true when @m1 == Matrix.new(<<same value>>)" do
    @m1.should == Matrix.new(Vector.new(-2, -1,  0, 0),
                             Vector.new( 1,  2,  3, 0),
                             Vector.new( 1,  0, -1, 0),
                             Vector.new( 4,  2,  1, 1))
  end

  it "should return correct Matrix when multiply two matrix" do
    (@m1 * @m2).should == Matrix.new(Vector.new(-4,-8,-5, 0),
                                     Vector.new(11, 1,16, 0),
                                     Vector.new(-1, 5,-2, 0),
                                     Vector.new(11,16,16, 1))
  end
end

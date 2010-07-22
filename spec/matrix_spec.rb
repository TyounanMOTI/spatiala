require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Matrix do
  before do
    @m1 = Matrix.new(Vector.new(-2, -1,  0),
                     Vector.new( 1,  2,  3),
                     Vector.new( 1,  0, -1),
                     Vector.new( 4,  2,  1))

  end

  it "should initialize with 4*3 vectors" do
    @m1.should be_instance_of Matrix
  end

  it "should have row vector" do
    @m1.row(1).should == Vector.new(1, 2, 3)
  end
end

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Crack do
  before do
    @ray1 = Ray.new(Vector.new(1,0), Vector.new(1,1))
    @ray2 = Ray.new(Vector.new(2,2), Vector.new(3,4))
    @ray3 = Ray.new(Vector.new(5,3), Vector.new(3,6))
    @crack = Crack.new(@ray1, @ray2, @ray3)
  end

  it "should initialize with line and Rays" do
    Crack.new(@ray1, @ray2, @ray3)
  end

  it "should initialize with line" do
    Crack.new(@ray1)
  end

  it "should have line and rays" do
    @crack.line.should be_instance_of Ray
    @crack.rays.each { |i| i.should be_instance_of Ray }
  end
  end
end

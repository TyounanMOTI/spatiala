require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Ray do
  it "should generate instance" do
    Ray.new.should be_instance_of Ray
  end

  it "should origin=(3,4), destination(-6,0), delta=(-9,-4) when initialize in that origin, destination=(-6,0)" do
    ray = Ray.new(Vector.new(3,4), Vector.new(-6,0))
    ray.origin.should == Vector.new(3,4)
    ray.delta.should == Vector.new(-9,-4)
    ray.destination.should == Vector.new(-6,0)
  end

  it "should return num between 0 and 1 when intersect (0,1)->(2,4) with (1,0)->(4,3)" do
    ray1 = Ray.new(Vector.new(1,0), Vector.new(2,4))
    ray2 = Ray.new(Vector.new(0,1), Vector.new(4,3))
    result = ray1.intersect(ray2)
    result.should < 1
    result.should > 0
  end
end

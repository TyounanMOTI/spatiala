require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Ray do
  before do
    @refrector = Ray.new(Vector.new(0,1), Vector.new(0,-1))
  end

  it "should generate instance" do
    Ray.new.should be_instance_of Ray
  end

  it "should origin=(3,4), destination(-6,0), delta=(-9,-4) when initialize in that origin, destination=(-6,0)" do
    ray = Ray.new(Vector.new(3,4), Vector.new(-6,0))
    ray.origin.should == Vector.new(3,4)
    ray.delta.should == Vector.new(-9,-4)
    ray.destination.should == Vector.new(-6,0)
  end

  it "should return num between 0 and 1 when intersect (1,0)->(2,4) with (0,1)->(4,3)" do
    ray1 = Ray.new(Vector.new(1,0), Vector.new(2,4))
    ray2 = Ray.new(Vector.new(0,1), Vector.new(4,3))
    result = ray1.intersect(ray2)
    result.should < 1
    result.should > 0
  end

  it "should re-compute delta when origin is changed" do
    ray = Ray.new(Vector.new(1,0), Vector.new(2,4))
    ray.origin = Vector.new(3,9)
    ray.delta.should == Vector.new(-1,-5)
  end

  it "should re-compute delta when destination is changed" do
    ray = Ray.new(Vector.new(1,0), Vector.new(2,4))
    ray.destination = Vector.new(3,9)
    ray.delta.should == Vector.new(2,9)
  end

  it "should re-compute destination when delta is changed" do
    ray = Ray.new(Vector.new(1,0), Vector.new(2,4))
    ray.delta = Vector.new(3,9)
    ray.destination.should == Vector.new(4,9)
  end

  it "should true when Ray((1,0),(4,2)) intersect? ((0,1),(3,4))" do
    ray = Ray.new(Vector.new(0,1), Vector.new(4,2))
    wall = Ray.new(Vector.new(1,0), Vector.new(3,4))
    ray.intersect?(wall).should == true
  end

  it "should true when Ray((1,0),(4,2)) == Ray((1,0),(4,2))" do
    Ray.new(Vector.new(1,0), Vector.new(4,2)).should == Ray.new(Vector.new(1,0), Vector.new(4,2))
  end

  it "should false when Ray((1,0),(4,2)) == Ray((0,1),(5,6))" do
    Ray.new(Vector.new(1,0), Vector.new(4,2)).should_not == Ray.new(Vector.new(0,1), Vector.new(5,6))
  end

  it "should transform Ray((1,0),(4,2)) to Ray((3,2),(6,4)) when Matrix.translator(2,2)" do
    Ray.new(Vector.new(1,0), Vector.new(4,2)).transform(Matrix.translator(2,2,0)).should == Ray.new(Vector.new(3,2), Vector.new(6,4))
  end

  it "should return VisibilityRegion when dualize" do
    Ray.new(Vector.new(1,0), Vector.new(4,2)).dualize.should be_instance_of VisibilityRegion
  end

  it "should have four Rays in VisibilityRegion when dualize Ray (3,-1) to (1,1)" do
    result = Ray.new(Vector.new(3,-1), Vector.new(1,1)).dualize
    result.rays.length.should == 4
  end

  it "should return nil when dualize Ray which isn't facing with reference refrector" do
    Ray.new(Vector.new(1,1), Vector.new(3,-1)).dualize.should be_nil
  end

  it "should return Vector when normal of Ray (1,1) to (3,-1) is requested" do
    normal = Ray.new(Vector.new(1,1), Vector.new(3,-1)).normal
    normal.should be_instance_of Vector
  end

  it "should return :false when questioned 'How refrector and Ray (1,1) to (2,-3) are facing?'" do
    ray = Ray.new(Vector.new(1,1), Vector.new(2,-3))
    @refrector.facing(ray).should == :false
  end

  it "should return :upper when questioned 'How refrector and Ray (2,0) to (3,0) are facing?'" do
    ray = Ray.new(Vector.new(2,0), Vector.new(3,0))
    @refrector.facing(ray).should == :upper
  end

  it "should return :lower when questioned 'How refrector and Ray (3,0) to (2,0) are facing?'" do
    ray = Ray.new(Vector.new(3,0), Vector.new(2,0))
    @refrector.facing(ray).should == :lower
  end

  it "should return :true when questioned 'How refrector and Ray (2,-3) to (1,1) are facing?'" do
    ray = Ray.new(Vector.new(2,-3), Vector.new(1,1))
    @refrector.facing(ray).should == :true
  end
end
